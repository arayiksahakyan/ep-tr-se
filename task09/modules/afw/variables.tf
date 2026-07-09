variable "location" {
  description = "Azure region for all Azure Firewall resources."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group where Azure Firewall resources are created."
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the existing virtual network that will receive AzureFirewallSubnet."
  type        = string
}

variable "aks_subnet_id" {
  description = "Resource ID of the existing AKS subnet to associate with the route table."
  type        = string
}

variable "aks_subnet_address_prefix" {
  description = "CIDR prefix of the existing AKS subnet used as source addresses in firewall rules."
  type        = string
}

variable "firewall_subnet_address_prefix" {
  description = "CIDR prefix for AzureFirewallSubnet."
  type        = string
}

variable "fw_name" {
  description = "Name of the Azure Firewall resource."
  type        = string
}

variable "fw_public_ip_name" {
  description = "Name of the Azure Firewall public IP resource."
  type        = string
}

variable "fw_sku_name" {
  description = "Azure Firewall SKU name."
  type        = string
}

variable "fw_sku_tier" {
  description = "Azure Firewall SKU tier."
  type        = string
}

variable "route_table_name" {
  description = "Name of the route table associated with the AKS subnet."
  type        = string
}

variable "default_route_name" {
  description = "Name of the default route that sends traffic to Azure Firewall."
  type        = string
}

variable "route_address_prefix" {
  description = "Address prefix for the route that sends traffic to Azure Firewall."
  type        = string
}

variable "firewall_public_ip_return_route_name" {
  description = "Name of the route that sends return traffic to the Azure Firewall public IP through Internet."
  type        = string
}

variable "application_rule_collection_name" {
  description = "Name of the Azure Firewall application rule collection."
  type        = string
}

variable "application_rule_collection_priority" {
  description = "Priority for the Azure Firewall application rule collection."
  type        = number
}

variable "application_rule_fqdn_tags" {
  description = "FQDN tags allowed by Azure Firewall application rules."
  type        = list(string)
}

variable "application_rule_target_fqdns" {
  description = "Target FQDNs allowed by Azure Firewall application rules."
  type        = list(string)
}

variable "network_rule_collection_name" {
  description = "Name of the Azure Firewall network rule collection."
  type        = string
}

variable "network_rule_collection_priority" {
  description = "Priority for the Azure Firewall network rule collection."
  type        = number
}

variable "network_rule_destination_addresses" {
  description = "Destination addresses allowed by Azure Firewall network rules."
  type        = list(string)
}

variable "nat_rule_collection_name" {
  description = "Name of the Azure Firewall NAT rule collection."
  type        = string
}

variable "nat_rule_collection_priority" {
  description = "Priority for the Azure Firewall NAT rule collection."
  type        = number
}

variable "nat_rule_source_addresses" {
  description = "Source addresses allowed to access the HTTP DNAT rule."
  type        = list(string)
}

variable "nat_rule_destination_port" {
  description = "Destination port on the Azure Firewall public IP for HTTP inbound traffic."
  type        = string
}

variable "nat_rule_translated_port" {
  description = "Translated port on the AKS LoadBalancer service."
  type        = string
}

variable "aks_loadbalancer_ip" {
  type        = string
  description = "Public IP address of the existing AKS load balancer used as the translated address in the Azure Firewall DNAT rule."
}
