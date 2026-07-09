variable "location" {
  description = "Azure region where the Azure Firewall resources are created."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group that contains the VNet and AKS cluster."
  type        = string
}

variable "vnet_name" {
  description = "Name of the existing virtual network where the firewall subnet is created."
  type        = string
}

variable "aks_subnet_name" {
  description = "Name of the existing AKS subnet that receives the route table association."
  type        = string
}

variable "aks_cluster_name" {
  description = "Name of the existing AKS cluster whose node resource group contains the load balancer network security group."
  type        = string
}

variable "aks_subnet_address_prefix" {
  description = "CIDR prefix of the existing AKS subnet used as the source for firewall rules."
  type        = string

  validation {
    condition     = can(cidrhost(var.aks_subnet_address_prefix, 0))
    error_message = "The AKS subnet address prefix must be a valid CIDR block."
  }
}

variable "firewall_subnet_address_prefix" {
  description = "Non-overlapping CIDR prefix for the required AzureFirewallSubnet."
  type        = string

  validation {
    condition     = can(cidrhost(var.firewall_subnet_address_prefix, 0))
    error_message = "The Azure Firewall subnet address prefix must be a valid CIDR block."
  }
}

variable "firewall_public_ip_name" {
  description = "Name of the Azure Firewall public IP resource."
  type        = string
}

variable "firewall_name" {
  description = "Name of the Azure Firewall resource."
  type        = string
}

variable "firewall_sku_name" {
  description = "Azure Firewall SKU name."
  type        = string
}

variable "firewall_sku_tier" {
  description = "Azure Firewall SKU tier."
  type        = string
}

variable "route_table_name" {
  description = "Name of the route table associated with the existing AKS subnet."
  type        = string
}

variable "default_route_name" {
  description = "Name of the default route that sends AKS subnet traffic through Azure Firewall."
  type        = string
}

variable "route_address_prefix" {
  description = "Address prefix for the default route that sends traffic to Azure Firewall."
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

variable "aks_node_port_range" {
  description = "Kubernetes NodePort port range used by AKS LoadBalancer backend and health probe traffic."
  type        = string
}

variable "aks_nsg_rule_name" {
  description = "Name of the AKS node NSG rule that allows HTTP access from Azure Firewall public IP to the AKS load balancer IP."
  type        = string
}

variable "aks_nsg_rule_priority" {
  description = "Priority of the AKS node NSG rule that allows HTTP access from Azure Firewall public IP to the AKS load balancer IP."
  type        = number
}
