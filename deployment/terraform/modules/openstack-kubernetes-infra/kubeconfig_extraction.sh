#!/usr/bin/env bash
set -euo pipefail

# ==============================
# Variables (from Terraform)
# ==============================
PATH_ROOT=${path.root}
SERVER_IP=${openstack_compute_instance_v2.kubernetes_server.access_ip_v4}
SSH_KEY=${local.ssh_keys.private_key_file}
KUBECONFIG_FILE=${local.kubeconfig_file}

# ==============================
# Script Logic
# ==============================

# Create .build directory if it doesn't exist
mkdir -p "${PATH_ROOT}/.build/"

# Add server's SSH key to a custom known_hosts file
ssh-keyscan -H "${SERVER_IP}" >> "${PATH_ROOT}/.build/.known_hosts_cogstack"

# Securely copy the K3s kubeconfig file from the server
scp \
  -o UserKnownHostsFile="${PATH_ROOT}/.build/.known_hosts_cogstack" \
  -o StrictHostKeyChecking=yes \
  -i "${SSH_KEY}" \
  "ubuntu@${SERVER_IP}:/etc/rancher/k3s/k3s.yaml" \
  "${KUBECONFIG_FILE}"

# Replace localhost with the actual server IP in the kubeconfig
sed -i "s/127\.0\.0\.1/${SERVER_IP}/" "${KUBECONFIG_FILE}"

echo "Kubeconfig successfully fetched and updated at: ${KUBECONFIG_FILE}"