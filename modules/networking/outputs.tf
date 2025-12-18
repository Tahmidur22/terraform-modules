output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.network.id
}
output "aks_subnet_id" {
  description = "The ID of the AKS Private Subnet"
  value       = azurerm_subnet.aks_private_subnet.id
}
output "aks_nsg_id" {
  description = "The ID of the NSG attached to the AKS subnet"
  value       = azurerm_network_security_group.aks_private_subnet_nsg.id
}