output "cluster_name" {
  description = "The name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.name
}
output "cluster_id" {
  description = "The ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.id

}
output "kubelet_identity" {
  description = "The object ID of the kubelet identity for the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id
}

output "aks_node_resource_group" {
  description = "The name of the resource group containing the AKS nodes."
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "kube_config" {
  description = "The kubeconfig file content for the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_config[0]
  sensitive   = true
}
