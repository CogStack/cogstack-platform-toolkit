module "openstack_cogstack_infra" {
  source = "../../modules/openstack-cogstack-infra"
  host_instances = [
    { name = "cogstack-devops", is_controller = true },
    { name = "medcat-nlp" }
  ]
  portainer_secrets        = var.portainer_secrets
  allowed_ingress_ips_cidr = var.allowed_ingress_ips_cidr
  ubuntu_immage_name       = var.ubuntu_immage_name

  # Optionally reuse an existing SSH Keypair to use for login, otherwise it wil generate a new one
  # ssh_key_pair = {
  #   private_key_file = "~/.ssh/my_existing_key",
  #   public_key_file = "~/.ssh/my_existing_key.pub"
  # }
}

module "cogstack_docker_services" {
  source = "../../modules/cogstack-docker-services"
  hosts  = module.openstack_cogstack_infra.created_hosts
  service_targets = {
    observability  = { hostname = "cogstack-devops" }
    medcat_service = { hostname = "medcat-nlp" }
  }
  portainer_secrets    = var.portainer_secrets
  ssh_private_key_file = module.openstack_cogstack_infra.compute_keypair.private_key_file
}
