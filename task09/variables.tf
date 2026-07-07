variable "location" {
  description = "Azure region where the Azure Firewall resources are created."
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the existing resource group that contains the VNet and AKS cluster."
  type        = string
  default     = "cmtr-2gvu1fsw-mod9-rg"
}

variable "vnet_name" {
  description = "Name of the existing virtual network where the firewall subnet is created."
  type        = string
  default     = "cmtr-2gvu1fsw-mod9-vnet"
}

variable "aks_subnet_name" {
  description = "Name of the existing AKS subnet that receives the route table association."
  type        = string
  default     = "aks-snet"
}

variable "aks_subnet_address_prefix" {
  description = "CIDR prefix of the existing AKS subnet used as the source for firewall rules."
  type        = string
  default     = "10.0.0.0/24"

  validation {
    condition     = can(cidrhost(var.aks_subnet_address_prefix, 0))
    error_message = "The AKS subnet address prefix must be a valid CIDR block."
  }
}

variable "firewall_subnet_address_prefix" {
  description = "Non-overlapping CIDR prefix for the required AzureFirewallSubnet."
  type        = string
  default     = "10.0.1.0/26"

  validation {
    condition     = can(cidrhost(var.firewall_subnet_address_prefix, 0))
    error_message = "The Azure Firewall subnet address prefix must be a valid CIDR block."
  }
}

variable "aks_loadbalancer_ip" {
  description = "Public IP address of the existing AKS LoadBalancer service that receives DNAT traffic."
  type        = string

  validation {
    condition     = can(cidrhost("${var.aks_loadbalancer_ip}/32", 0))
    error_message = "The AKS LoadBalancer IP must be a valid IPv4 address."
  }
}
