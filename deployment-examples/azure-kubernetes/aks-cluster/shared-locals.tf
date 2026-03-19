locals {
  random_prefix = random_id.prefix.b64_url
}
resource "random_id" "prefix" {
  byte_length = 4
}

locals {
  kubeconfig_file      = "${path.module}/.build/aks-kubeconfig.yaml"
  created_cluster_name = module.aks.resource.name
}