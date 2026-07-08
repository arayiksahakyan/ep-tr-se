provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_subnet" "aks" {
  name                 = var.aks_subnet_name
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = data.azurerm_resource_group.this.name
}

module "afw" {
  source = "./modules/afw"

  location                       = var.location
  resource_group_name            = data.azurerm_resource_group.this.name
  virtual_network_name           = data.azurerm_virtual_network.this.name
  aks_subnet_id                  = data.azurerm_subnet.aks.id
  aks_subnet_address_prefix      = var.aks_subnet_address_prefix
  firewall_subnet_address_prefix = var.firewall_subnet_address_prefix

  fw_name           = var.firewall_name
  fw_public_ip_name = var.firewall_public_ip_name
  fw_sku_name       = var.firewall_sku_name
  fw_sku_tier       = var.firewall_sku_tier

  route_table_name     = var.route_table_name
  default_route_name   = var.default_route_name
  route_address_prefix = var.route_address_prefix

  application_rule_collection_name     = var.application_rule_collection_name
  application_rule_collection_priority = var.application_rule_collection_priority
  application_rule_fqdn_tags           = var.application_rule_fqdn_tags
  application_rule_target_fqdns        = var.application_rule_target_fqdns

  network_rule_collection_name       = var.network_rule_collection_name
  network_rule_collection_priority   = var.network_rule_collection_priority
  network_rule_destination_addresses = var.network_rule_destination_addresses

  nat_rule_collection_name     = var.nat_rule_collection_name
  nat_rule_collection_priority = var.nat_rule_collection_priority
  nat_rule_source_addresses    = var.nat_rule_source_addresses
  nat_rule_destination_port    = var.nat_rule_destination_port
  nat_rule_translated_port     = var.nat_rule_translated_port
  aks_loadbalancer_ip          = var.aks_loadbalancer_ip
}
