output "azure_firewall_public_ip" {
  description = "Public IP address assigned to Azure Firewall."
  value       = module.afw.azure_firewall_public_ip
}

output "azure_firewall_private_ip" {
  description = "Private IP address assigned to Azure Firewall."
  value       = module.afw.azure_firewall_private_ip
}
