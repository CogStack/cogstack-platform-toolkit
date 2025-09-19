resource "null_resource" "copy_kubeconfig" {
  depends_on = [openstack_compute_instance_v2.kubernetes_server]

  provisioner "local-exec" {
    # Copy the kubeconfig file from the host to a local file using SCP.
    # Use ssh-keyscan to prevent interactive prompt on unknown host
    # Use sed to replace the localhost address in the KUBECONFIG file with the actual IP adddress of the created VM. 
    command = <<EOT
mkdir -p ${path.root}/.build/ && \
ssh-keyscan -H ${openstack_compute_instance_v2.kubernetes_server.access_ip_v4} >> ${path.root}/.build/.known_hosts_cogstack && \
scp -o UserKnownHostsFile=${path.root}/.build/.known_hosts_cogstack -o StrictHostKeyChecking=yes \
    -i ${local.ssh_keys.private_key_file} \
    ubuntu@${openstack_compute_instance_v2.kubernetes_server.access_ip_v4}:/etc/rancher/k3s/k3s.yaml \
    ${local.kubeconfig_file} && \
sed -i "s/127.0.0.1/${openstack_compute_instance_v2.kubernetes_server.access_ip_v4}/" ${local.kubeconfig_file}
EOT
  }
}

data "local_file" "kube_config_raw_file" {
  filename = local.kubeconfig_file
  depends_on = [ null_resource.copy_kubeconfig ]
}

output "kube_config_raw" {
  value = data.local_file.kube_config_raw_file
  description = "Kubeconfig for this cluster"
}