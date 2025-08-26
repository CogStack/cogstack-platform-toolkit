
module "cogstack_docker_services" {
  source = "../../../modules/cogstack-docker-services"
  hosts  = var.hosts
  service_targets = {
    observability  = { hostname = "cogstack-devops" }
    medcat_service = { hostname = "medcat-nlp" }
  }
  ssh_private_key_file = var.ssh_private_key_file
}
