resource "azurerm_key_vault" "kv" {
  name                = "akstestkeyvault"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  soft_delete_retention_days = 7
}

resource "azurerm_key_vault_secret" "datadog_api_key" {
  name         = "DatadogApiKey"
  value        = var.datadog_api_key
  key_vault_id = azurerm_key_vault.kv.id
  
}