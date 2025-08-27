
locals {
  random_prefix = random_id.server.b64_url
}


locals {
  controller_host          = one([for host in var.host_instances : host if host.is_controller])
  controller_host_instance = openstack_compute_instance_v2.cogstack_ops_compute[local.controller_host.name]
}

resource "random_id" "server" {
  keepers = {
    # Generate a new id each time we recreate the hosts
    cloud_init_config            = data.cloudinit_config.init_docker.id
    cloud_init_config_controller = data.cloudinit_config.init_docker_controller.id
  }

  byte_length = 4
}

resource "random_password" "portainer_password" {
  count  = var.portainer_secrets.admin_password != null ? 0 : 1
  length = 16
}
locals {
  portainer_admin_password = var.portainer_secrets.admin_password != null ? var.portainer_secrets.admin_password : random_password.portainer_password[0].result
}
