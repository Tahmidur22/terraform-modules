resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  private_cluster_enabled = true
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name            = "system"
    node_count      = var.system_node_count
    vm_size         = var.system_vm_size
    vnet_subnet_id  = var.vnet_subnet_id
    min_count       = var.system_min_nodes
    max_count       = var.system_max_nodes
    os_disk_size_gb = 128
  }

  identity { type = "SystemAssigned" }
}