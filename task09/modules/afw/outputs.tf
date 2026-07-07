output "azure_firewall_public_ip" {
  description = "Public IP address assigned to Azure Firewall."
  value       = azurerm_public_ip.firewall.ip_address
}

output "azure_firewall_private_ip" {
  description = "Private IP address assigned to Azure Firewall."
  value       = azurerm_firewall.this.ip_configuration[0].private_ip_address
}
