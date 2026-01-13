

locals {
  devops_controller_cidr = "${local.controller_host_instance.ip_address}/32"

  cogstack_apps_ingress_rules = [
    { port = 22, cidr = var.allowed_ingress_ips_cidr, description = "Expose SSH" },
    { port = 80, cidr = var.allowed_ingress_ips_cidr, description = "Expose port 80 (hhtp) for ingress" },
    { port = 443, cidr = var.allowed_ingress_ips_cidr, description = "Expose port 443 (https) for ingress" },
    { port = 6443, cidr = var.allowed_ingress_ips_cidr, description = "Expose kubernetes for CLI" }
  ]
  cogstack_apps_ingress_rules_map = { for rule in local.cogstack_apps_ingress_rules : "${rule.port}-${rule.description}" => rule }
}

resource "openstack_networking_secgroup_v2" "cogstack_apps_security_group" {
  name        = local.prefix != "" ? "${local.prefix}-cogstack-services" : "cogstack-services"
  description = "Cogstack Apps and Services Group"
}

resource "openstack_networking_secgroup_rule_v2" "cogstack_apps_port_rules" {
  for_each          = local.cogstack_apps_ingress_rules_map
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = each.value.port
  port_range_max    = each.value.port
  remote_ip_prefix  = each.value.cidr
  description       = each.value.description
  security_group_id = openstack_networking_secgroup_v2.cogstack_apps_security_group.id
}

