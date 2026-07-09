locals {
  aks_subnet_nsg_id = try(data.azurerm_subnet.aks.network_security_group_id, null)

  aks_subnet_nsg_rules = local.aks_subnet_nsg_id == null || local.aks_subnet_nsg_id == "" ? {} : {
    aks_subnet_nsg = {
      id   = local.aks_subnet_nsg_id
      name = element(split("/", local.aks_subnet_nsg_id), length(split("/", local.aks_subnet_nsg_id)) - 1)
      rg   = element(split("/", local.aks_subnet_nsg_id), 4)
    }
  }
}
