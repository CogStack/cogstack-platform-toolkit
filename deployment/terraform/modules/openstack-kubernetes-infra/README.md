# Cogstack Opesntack K3S Module

Terraform Module for provisioning VMs on Openstack as a kubernetes cluster using K3s

## Features
- Create a multi node kuberentes cluster in Openstack with K3s
- Create VMs and initialise their setup using K3s install scripts
- Setup Networking in Openstack to allow communications between expected services
- Return a KUBECONFIG file for integration with kubernetes and helm providers in terraform

## Requirements
- An Openstack Environment able to create Compute and Networking rules
- An accessible Ubuntu image in the openstack environment

## Example

```hcl
module "openstack_kubernetes_cluster" {
  source = "../../modules/openstack-kubernetes-infra"
  host_instances = [
    { name = "cogstack-k3s-server", is_controller = true },
    { 
      name          = "cogstack-k3s-node-2"
      flavour       = "2cpu4ram"
      volume_size   = 20
      is_controller = false
    },
  ]
  allowed_ingress_ips_cidr = "0.0.0.0/24"
  ubuntu_immage_name       = "Ubuntu_Jammy""
  ssh_key_pair = {
    private_key_file = "~/.ssh/id_rsa",
    public_key_file  = "~/.ssh/id_rsa.pub",
  }
}
```


