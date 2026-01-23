variable "resource_group_name" {
    description = "The name of the resource group where the Key Vault will be created."
    type        = string
}
variable "location" {
    description = "The Azure location where the Key Vault will be created."
    type        = string
}
variable "kv_name" {
    description = "The name of the Key Vault."
    type        = string
}
