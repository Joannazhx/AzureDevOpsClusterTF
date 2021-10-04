# Azure AKS Outputs

output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_cluster_kubernetes_version" {
  value = azurerm_kubernetes_cluster.aks_cluster.kubernetes_version
}

output "kube_config" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
}

output "cluster_ca_certificate" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate
}

output "client_certificate" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate
}

output "client_key" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key
}

output "host" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
}