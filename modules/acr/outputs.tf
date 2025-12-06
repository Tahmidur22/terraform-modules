output "login_server" {
    description = "The login server URL of the Azure Container Registry."
    value       = azurerm_container_registry.container.login_server
}
output "acr_id" { 
    description = "The ID of the Azure Container Registry."
    value       = azurerm_container_registry.container.id
}