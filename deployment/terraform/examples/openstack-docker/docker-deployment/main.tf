
module "cogstack_docker_services" {
  source = "../../../modules/cogstack-docker-services"
  hosts  = var.hosts
  service_targets = {
    observability  = { hostname = "cogstack-docker-controller" }
    medcat_service = { hostname = "cogstack-docker-medcat-nlp" }
  }
  ssh_private_key_file = var.ssh_private_key_file
}
