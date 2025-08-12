
output "created_infra" {
  value = module.openstack_cogstack_infra
}

output "created_services" {
  value = module.cogstack_docker_services
}

output "portainer_webpage" {
  value = "https://${module.openstack_cogstack_infra.created_controller_host.ip_address}:9443"
}