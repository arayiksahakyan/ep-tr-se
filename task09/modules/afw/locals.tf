locals {
  firewall_subnet_name  = "AzureFirewallSubnet"
  ip_configuration_name = "azure-firewall-ip-configuration"

  aks_source_addresses = [
    var.aks_subnet_address_prefix,
  ]

  application_rule_protocols = [
    {
      type = "Http"
      port = 80
    },
    {
      type = "Https"
      port = 443
    },
  ]

  application_rules = merge(
    length(var.application_rule_fqdn_tags) > 0 ? {
      aks_fqdn_tags = {
        name         = "allow-aks-fqdn-tags"
        fqdn_tags    = distinct(var.application_rule_fqdn_tags)
        target_fqdns = []
        protocols    = []
      }
    } : {},
    length(var.application_rule_target_fqdns) > 0 ? {
      aks_required_fqdns = {
        name         = "allow-aks-required-fqdns"
        fqdn_tags    = []
        target_fqdns = distinct(var.application_rule_target_fqdns)
        protocols    = local.application_rule_protocols
      }
    } : {}
  )

  network_rules = {
    dns = {
      name                  = "allow-dns"
      source_addresses      = local.aks_source_addresses
      destination_ports     = ["53"]
      destination_addresses = var.network_rule_destination_addresses
      protocols             = ["TCP", "UDP"]
    }
    https = {
      name                  = "allow-https"
      source_addresses      = local.aks_source_addresses
      destination_ports     = ["443"]
      destination_addresses = var.network_rule_destination_addresses
      protocols             = ["TCP"]
    }
    aks_tunnel = {
      name                  = "allow-aks-tunnel"
      source_addresses      = local.aks_source_addresses
      destination_ports     = ["9000"]
      destination_addresses = var.network_rule_destination_addresses
      protocols             = ["TCP"]
    }
    vpn_tunnel = {
      name                  = "allow-vpn-tunnel"
      source_addresses      = local.aks_source_addresses
      destination_ports     = ["1194"]
      destination_addresses = var.network_rule_destination_addresses
      protocols             = ["UDP"]
    }
    ntp = {
      name                  = "allow-ntp"
      source_addresses      = local.aks_source_addresses
      destination_ports     = ["123"]
      destination_addresses = var.network_rule_destination_addresses
      protocols             = ["UDP"]
    }
    http_to_aks_loadbalancer = {
      name                  = "allow-http-to-aks-loadbalancer"
      source_addresses      = var.nat_rule_source_addresses
      destination_ports     = [var.nat_rule_destination_port]
      destination_addresses = [var.aks_loadbalancer_ip]
      protocols             = ["TCP"]
    }
  }
}
