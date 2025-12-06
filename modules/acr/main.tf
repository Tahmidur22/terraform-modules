resource "azuerm_container_registry" "container" {
    name                     = var.acr_name
    resource_group_name      = var.resource_group_name
    location                 = var.location
    sku                      = var.acr_sku
    admin_enabled            = var.admin_enabled

    network_rule_set {
        default_action             = "Deny"

        virtual_network {
            subnet_id = var.aks_subnet_id
        }
    }
    
    tags = merge(var.tags, {
        module = "acr"
    })
}

