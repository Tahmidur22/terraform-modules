variable "cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
  
}
variable "location" {
  description = "The Azure location where the AKS cluster will be created."
  type        = string
}
variable "resource_group_name" {
    description = "The name of the resource group in which to create the AKS cluster."
    type        = string
}
variable "dns_prefix" {
    description = "The DNS prefix for the AKS cluster."
    type        = string
}
variable "kubernetes_version" {
    description = "The Kubernetes version for the AKS cluster."
    type        = string
    default     = "1.24.6"
}
variable "system_node_count" {
    description = "The initial number of nodes in the system node pool."
    type        = number
    default     = 3
}
variable "system_vm_size" {
    description = "The VM size for the system node pool."
    type        = string
    default     = "Standard_DS2_v2"
}
variable "system_min_nodes" {
    description = "The minimum number of nodes for the system node pool autoscaler."
    type        = number
    default     = 3
}
variable "system_max_nodes" {
    description = "The maximum number of nodes for the system node pool autoscaler."
    type        = number
    default     = 10
}
variable "vnet_subnet_id" {
    description = "The ID of the virtual network subnet to which the AKS cluster will be connected."
    type        = string        
}