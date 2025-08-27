module "openstack_cogstack_infra" {
  source = "../../../modules/openstack-cogstack-infra"
  host_instances = [
    { name = "cogstack-docker-controller", is_controller = true },
    { name = "cogstack-docker-medcat-nlp" }
  ]
  allowed_ingress_ips_cidr = var.allowed_ingress_ips_cidr
  ubuntu_immage_name       = var.ubuntu_immage_name
}
