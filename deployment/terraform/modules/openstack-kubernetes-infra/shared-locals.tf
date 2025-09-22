
locals {
  random_prefix = random_id.server.b64_url
}


locals {
  controller_host          = one([for host in var.host_instances : host if host.is_controller])
  controller_host_instance = openstack_compute_instance_v2.kubernetes_server
}

locals {
  output_file_directory = var.output_file_directory != null ? var.output_file_directory : "${path.root}/.build"
  kubeconfig_file = "${local.output_file_directory}/downloaded-kubeconfig.yaml"
}

resource "random_id" "server" {
  keepers = {
    # Generate a new id each time we recreate the hosts
    cloud_init_config_controller = data.cloudinit_config.init_docker_controller.id
  }

  byte_length = 4
}