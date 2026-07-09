resource "azurerm_subnet" "firewall" {
  name                 = local.firewall_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.firewall_subnet_address_prefix]
}

resource "azurerm_public_ip" "firewall" {
  name                = var.fw_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_firewall" "this" {
  name                = var.fw_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.fw_sku_name
  sku_tier            = var.fw_sku_tier

  ip_configuration {
    name                 = local.ip_configuration_name
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

resource "azurerm_route_table" "aks" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_route" "default_to_firewall" {
  name                   = var.default_route_name
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.aks.name
  address_prefix         = var.route_address_prefix
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.this.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "aks" {
  subnet_id      = var.aks_subnet_id
  route_table_id = azurerm_route_table.aks.id

  depends_on = [
    azurerm_route.default_to_firewall,
  ]
}

resource "azurerm_firewall_application_rule_collection" "aks" {
  name                = var.application_rule_collection_name
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name
  priority            = var.application_rule_collection_priority
  action              = "Allow"

  dynamic "rule" {
    for_each = local.application_rules

    content {
      name             = rule.value.name
      source_addresses = local.aks_source_addresses
      fqdn_tags        = length(rule.value.fqdn_tags) > 0 ? rule.value.fqdn_tags : null
      target_fqdns     = length(rule.value.target_fqdns) > 0 ? rule.value.target_fqdns : null

      dynamic "protocol" {
        for_each = rule.value.protocols

        content {
          type = protocol.value.type
          port = protocol.value.port
        }
      }
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "aks" {
  name                = var.network_rule_collection_name
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name
  priority            = var.network_rule_collection_priority
  action              = "Allow"

  dynamic "rule" {
    for_each = local.network_rules

    content {
      name                  = rule.value.name
      source_addresses      = local.aks_source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      protocols             = rule.value.protocols
    }
  }

}

resource "azurerm_firewall_nat_rule_collection" "aks_http" {
  name                = var.nat_rule_collection_name
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name
  priority            = var.nat_rule_collection_priority
  action              = "Dnat"

  rule {
    name                  = "dnat-http-to-aks"
    source_addresses      = var.nat_rule_source_addresses
    destination_ports     = [var.nat_rule_destination_port]
    destination_addresses = [azurerm_public_ip.firewall.ip_address]
    translated_address    = var.aks_loadbalancer_ip
    translated_port       = var.nat_rule_translated_port
    protocols             = ["TCP"]
  }
}
