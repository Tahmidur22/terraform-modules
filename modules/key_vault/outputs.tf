output "key_vault_id" {
    description = "The ID of the Key Vault"
    value       = azurerm_key_vault.kv.id
}

output "datadig_secret_name" {
    description = "The name of the Datadog API key secret"
    value       = azurerm_key_vault_secret.datadog_api_key.name
}