resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.cluster_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = var.dns_prefix
  private_cluster_enabled = false
  kubernetes_version      = var.kubernetes_version

  default_node_pool {
    name            = "system"
    node_count      = var.system_node_count
    vm_size         = var.system_vm_size
    vnet_subnet_id  = var.vnet_subnet_id    
    os_disk_size_gb = 128
  }

  identity { type = "SystemAssigned" }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "172.16.0.0/16"    
    dns_service_ip = "172.16.0.10"      
  }
}