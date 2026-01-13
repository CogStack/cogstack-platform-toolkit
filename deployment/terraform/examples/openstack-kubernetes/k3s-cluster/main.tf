module "openstack_cogstack_infra" {
  source = "../../../modules/openstack-kubernetes-infra"
  host_instances = [
    { name = "cogstack-k3s", is_controller = true },
    {
      name          = "cogstack-k3s-node-2"
      flavour       = "2cpu4ram"
      volume_size   = 20
      is_controller = false
    },
  ]
  allowed_ingress_ips_cidr = var.allowed_ingress_ips_cidr
  ubuntu_immage_name       = var.ubuntu_immage_name
  generate_random_id       = false
}
