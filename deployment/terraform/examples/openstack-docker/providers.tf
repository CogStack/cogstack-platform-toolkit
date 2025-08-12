terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0.0"
    }
    portainer = {
      source  = "portainer/portainer"
      version = "1.4.2"
    }
    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }
  }
}

provider "openstack" {
  insecure                      = true
  enable_logging                = true
  auth_url                      = var.openstack_environment.openstack_auth_url
  application_credential_id     = var.openstack_environment.openstack_application_credential_id
  application_credential_secret = var.openstack_environment.openstack_application_credential_secret
  region                        = var.openstack_environment.region
}

provider "portainer" {
  endpoint        = "https://${module.openstack_cogstack_infra.created_controller_host.ip_address}:9443"
  api_key         = var.portainer_secrets.api_key
  skip_ssl_verify = true # optional (default value is `false`)
}
