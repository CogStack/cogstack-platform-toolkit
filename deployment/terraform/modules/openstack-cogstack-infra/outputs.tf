output "created_hosts" {
  value = { for k, value in openstack_compute_instance_v2.cogstack_ops_compute : k => {
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

output "portainer_instance" {
  sensitive = true
  value = {
    endpoint = "https://${local.controller_host_instance.access_ip_v4}:9443"
    username = "admin"
    password = local.portainer_admin_password
  }
}
