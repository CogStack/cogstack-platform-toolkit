terraform {
  required_providers {
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