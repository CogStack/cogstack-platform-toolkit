

resource "openstack_compute_instance_v2" "kubernetes_server" {

  name      = "${local.random_prefix}-${local.controller_host.name}"
  flavor_id = data.openstack_compute_flavor_v2.available_compute_flavors[local.controller_host.flavour].id
  key_pair  = openstack_compute_keypair_v2.compute_keypair.name
  region    = "RegionOne"

  user_data = data.cloudinit_config.init_docker_controller.rendered
  security_groups = ["default",
    openstack_networking_secgroup_v2.cogstack_apps_security_group.name
  ]

  network {
    uuid = data.openstack_networking_network_v2.external_4003.id
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu.id
    source_type           = "image"
    volume_size           = local.controller_host.volume_size
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  connection {
    user        = "ubuntu"
    host        = self.access_ip_v4
    private_key = file(local.ssh_keys.private_key_file)
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait > /tmp/openstack-terraform-remote-exec-provisioner.log || true",
    ]
  }
}

resource "openstack_compute_instance_v2" "kubernetes_nodes" {
  depends_on = [openstack_compute_instance_v2.kubernetes_server]
  for_each   = { for vm in var.host_instances : vm.name => vm if !vm.is_controller }
  name       = "${local.random_prefix}-${each.value.name}"
  flavor_id  = data.openstack_compute_flavor_v2.available_compute_flavors[each.value.flavour].id
  key_pair   = openstack_compute_keypair_v2.compute_keypair.name
  region     = "RegionOne"

  user_data = data.cloudinit_config.init_docker.rendered
  security_groups = ["default",
    openstack_networking_secgroup_v2.cogstack_apps_security_group.name
  ]

  network {
    uuid = data.openstack_networking_network_v2.external_4003.id
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu.id
    source_type           = "image"
    volume_size           = each.value.volume_size
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  connection {
    user        = "ubuntu"
    host        = self.access_ip_v4
    private_key = file(local.ssh_keys.private_key_file)
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait > /tmp/openstack-terraform-remote-exec-provisioner.log || true",
    ]
  }
}



# TODO: Read content from files and put into cloud-init config
# data "local_file" "install_docker_sh" {
#   filename = "${path.module}/resources/install-docker.sh"
# }

# data "local_file" "initialize_portainer_binary" {
#   filename = "${path.module}/resources/portainer-init-snapshot.tar.gz"
# }


data "cloudinit_config" "init_docker" {
  depends_on = [openstack_compute_instance_v2.kubernetes_server]
  part {
    filename     = "cloud-init-k3s-agent.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init-k3s-agent.yaml",
      {
        TF_K3S_TOKEN             = random_password.k3s_token.result
        TF_K3S_SERVER_IP_ADDRESS = openstack_compute_instance_v2.kubernetes_server.access_ip_v4
      }
    )
  }
}

resource "random_password" "k3s_token" {
  length = 32
}

data "cloudinit_config" "init_docker_controller" {
  part {
    filename     = "cloud-init-k3s-server.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init-k3s-server.yaml",
      {
        TF_K3S_TOKEN = random_password.k3s_token.result
      }
    )
  }
}

data "openstack_compute_flavor_v2" "available_compute_flavors" {
  for_each = toset([for vm in var.host_instances : vm.flavour])
  name     = each.value
}


data "openstack_networking_network_v2" "external_4003" {
  name = "external_4003"
}

data "openstack_images_image_v2" "ubuntu" {
  name        = var.ubuntu_immage_name
  most_recent = true
}

data "openstack_networking_secgroup_v2" "er_https_from_lbs" {
  name = "er_https_from_lbs"
}

resource "null_resource" "copy_kubeconfig" {
  depends_on = [openstack_compute_instance_v2.kubernetes_server]

  provisioner "local-exec" {
    # Copy the kubeconfig file from the host to a local file using SCP.
    # Use ssh-keyscan to prevent interactive prompt on unknown host
    # Use sed to replace the localhost address in the KUBECONFIG file with the actual IP adddress of the created VM. 
    command = <<EOT
mkdir -p ${path.root}/.build/ && \
ssh-keyscan -H ${openstack_compute_instance_v2.kubernetes_server.access_ip_v4} >> ${path.root}/.build/.known_hosts_cogstack && \
scp -o UserKnownHostsFile=${path.root}/.build/.known_hosts_cogstack -o StrictHostKeyChecking=yes \
    -i ${local.ssh_keys.private_key_file} \
    ubuntu@${openstack_compute_instance_v2.kubernetes_server.access_ip_v4}:/etc/rancher/k3s/k3s.yaml \
    ${local.kubeconfig_file} && \
sed -i "s/127.0.0.1/${openstack_compute_instance_v2.kubernetes_server.access_ip_v4}/" ${local.kubeconfig_file}
EOT
  }
}