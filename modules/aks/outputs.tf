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
