location = "East US"

resource_group_name = "cmtr-2gvu1fsw-mod9-rg"
vnet_name           = "cmtr-2gvu1fsw-mod9-vnet"

aks_subnet_name                = "aks-snet"
aks_cluster_name               = "cmtr-2gvu1fsw-mod9-aks"
aks_subnet_address_prefix      = "10.0.0.0/24"
firewall_subnet_address_prefix = "10.0.1.0/26"

aks_loadbalancer_ip = "20.237.16.20"

aks_node_port_range   = "30000-32767"
aks_nsg_rule_name     = "AllowAccessFromFirewallPublicIPToLoadBalancerIP"
aks_nsg_rule_priority = 400

firewall_public_ip_name = "cmtr-2gvu1fsw-mod9-pip"
firewall_name           = "cmtr-2gvu1fsw-mod9-afw"
firewall_sku_name       = "AZFW_VNet"
firewall_sku_tier       = "Standard"

route_table_name     = "cmtr-2gvu1fsw-mod9-rt"
default_route_name   = "default-to-azure-firewall"
route_address_prefix = "0.0.0.0/0"

azure_load_balancer_probe_route_name     = "azure-load-balancer-health-probe"
azure_load_balancer_probe_address_prefix = "168.63.129.16/32"

application_rule_collection_name     = "aks-application-rules"
application_rule_collection_priority = 100
application_rule_fqdn_tags           = ["AzureKubernetesService"]
application_rule_target_fqdns = [
  "mcr.microsoft.com",
  "*.data.mcr.microsoft.com",
  "packages.microsoft.com",
  "acs-mirror.azureedge.net",
  "*.azmk8s.io",
]

network_rule_collection_name       = "aks-network-rules"
network_rule_collection_priority   = 110
network_rule_destination_addresses = ["*"]

nat_rule_collection_name     = "aks-http-dnat-rules"
nat_rule_collection_priority = 120
nat_rule_source_addresses    = ["*"]
nat_rule_destination_port    = "80"
nat_rule_translated_port     = "80"
