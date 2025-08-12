
locals {
  random_prefix = random_id.server.b64_url
}


locals {
  controller_host          = one([for host in var.host_instances : host if host.is_controller])
  controller_host_instance = openstack_compute_instance_v2.kubernetes_server
}

locals {
  kubeconfig_file = "${path.module}/.build/downloaded-kubeconfig.yaml"
}

resource "random_id" "server" {
  keepers = {
    # Generate a new id each time we recreate the hosts
    cloud_init_config_controller = data.cloudinit_config.init_docker_controller.id
  }

  byte_length = 4
}