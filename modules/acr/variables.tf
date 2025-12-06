variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group in which to create the Azure Container Registry."
  type        = string
}
variable "location" {
  description = "The Azure location where the Container Registry will be created."
  type        = string
}
variable "aks_subnet_id" {
  description = "The ID of the subnet to be used by the AKS cluster."
  type        = string

}
variable "acr_sku" {
  description = "The SKU of the Azure Container Registry."
  type        = string
  default     = "Standard"
}
variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled."
  type        = bool
  default     = false
}
variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}