variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  type        = string
}

variable "location" {
  description = "The Azure location where the virtual network will be created."
  type        = string
}
variable "address_space" {
  description = "The address space that is used by the virtual network."
  type        = list(string)
}
variable "aks_subnet_cidr" {
  description = "The CIDR block for the AKS private subnet."
  type        = string
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet."
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}
variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}