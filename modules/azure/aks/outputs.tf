output "cluster_name" {
  description = "AKS cluster name."
  value       = azurerm_kubernetes_cluster.this.name
}

output "cluster_id" {
  description = "AKS cluster resource ID."
  value       = azurerm_kubernetes_cluster.this.id
}

output "fqdn" {
  description = "Kubernetes API FQDN."
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "oidc_issuer_url" {
  description = "OIDC issuer used by workload identity."
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "identity_principal_id" {
  description = "Cluster managed identity principal ID."
  value       = azurerm_user_assigned_identity.cluster.principal_id
}
