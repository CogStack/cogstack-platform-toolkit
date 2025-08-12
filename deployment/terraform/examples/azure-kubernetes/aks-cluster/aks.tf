

module "aks" {
  # Using the Azure Verified Module AKS Dev/Test module
  # This is not recommended by Azure to be used for production deployments
  source              = "Azure/avm-ptn-aks-dev/azurerm"
  version             = "0.2.0"
  name                = module.naming.kubernetes_cluster.name_unique
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

# Alternative - use the Azure Verified Module AKS Production Module
# This is their recommended guidance for prod deployments. This requires more account permissions
#
# Datasource of current tenant ID
# data "azurerm_client_config" "current" {}
#
# module "avm-ptn-aks-production"  { 
#   source  = "Azure/avm-ptn-aks-production/azurerm" 
#   version = "0.5.0" 
#   location = azurerm_resource_group.this.location
#   name =  module.naming.kubernetes_cluster.name
#   network = {
#     node_subnet_id = module.avm_res_network_virtualnetwork.subnets["subnet"].resource_id
#     pod_cidr       = "192.168.0.0/16"
#     service_cidr   = "10.2.0.0/16"
#   }
#   resource_group_name = azurerm_resource_group.this.name
#   rbac_aad_tenant_id          = data.azurerm_client_config.current.tenant_id

# }

# module "avm_res_network_virtualnetwork" {
#   source  = "Azure/avm-res-network-virtualnetwork/azurerm"
#   version = "0.7.1"

#   address_space       = ["10.31.0.0/16"]
#   location            = azurerm_resource_group.this.location
#   name                = module.naming.virtual_network.name
#   resource_group_name = azurerm_resource_group.this.name
#   subnets = {
#     "subnet" = {
#       name             = "nodecidr"
#       address_prefixes = ["10.31.0.0/17"]
#     }
#     "private_link_subnet" = {
#       name             = "private_link_subnet"
#       address_prefixes = ["10.31.129.0/24"]
#     }
#   }
# }