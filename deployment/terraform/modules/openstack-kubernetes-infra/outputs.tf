
output "created_hosts" {
  value = { for k, value in merge(openstack_compute_instance_v2.kubernetes_nodes, [openstack_compute_instance_v2.kubernetes_server]) : k => {
    ip_address  = value.access_ip_v4
    unique_name = value.name
    name        = k
  } }

  description = "Created Hosts: A map of { hostname: { data } }"
}

output "created_controller_host" {
  value = {
    name        = (local.controller_host.name)
    ip_address  = local.controller_host_instance.access_ip_v4
    unique_name = local.controller_host_instance.name
  }

  description = "Created Controller Host: A map of { hostname: { data } }"
}

output "compute_keypair" {
  value = {
    public_key_file  = local.ssh_keys.public_key_file,
    private_key_file = local.ssh_keys.private_key_file,
  }
  description = "Absolute path to a public and private SSH key pair that is granted login on created VMs"
}

output "kubeconfig_file" {
  value       = abspath(local.kubeconfig_file)
  description = "Path to the generated KUBECONFIG file used to connect to kubernetes"
}
