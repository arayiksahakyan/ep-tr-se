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

  fw_name           = local.resource_names.firewall
  fw_public_ip_name = local.resource_names.firewall_public_ip

  route_table_name     = local.resource_names.route_table
  default_route_name   = local.resource_names.default_route
  route_address_prefix = "0.0.0.0/0"

  application_rule_collection_name = local.resource_names.application_rule_collection
  application_rule_fqdn_tags       = local.application_rule_fqdn_tags
  application_rule_target_fqdns    = local.application_rule_target_fqdns

  network_rule_collection_name       = local.resource_names.network_rule_collection
  network_rule_destination_addresses = local.network_rule_destination_addresses

  nat_rule_collection_name = local.resource_names.nat_rule_collection
  aks_loadbalancer_ip      = var.aks_loadbalancer_ip
}
