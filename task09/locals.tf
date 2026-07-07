locals {
  name_prefix = "cmtr-2gvu1fsw-mod9"

  resource_names = {
    firewall                    = format("%s-%s", local.name_prefix, "afw")
    firewall_public_ip          = format("%s-%s", local.name_prefix, "pip")
    route_table                 = format("%s-%s", local.name_prefix, "rt")
    default_route               = "default-to-azure-firewall"
    application_rule_collection = "aks-application-rules"
    network_rule_collection     = "aks-network-rules"
    nat_rule_collection         = "aks-http-dnat-rules"
  }

  application_rule_fqdn_tags = [
    "AzureKubernetesService",
  ]

  application_rule_target_fqdns = distinct(compact([
    "mcr.microsoft.com",
    "*.data.mcr.microsoft.com",
    "packages.microsoft.com",
    "acs-mirror.azureedge.net",
    "*.azmk8s.io",
  ]))

  network_rule_destination_addresses = [
    "*",
  ]
}
