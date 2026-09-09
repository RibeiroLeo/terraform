output "cluster_name" {
  description = "AKS cluster name."
  value       = module.aks.cluster_name
}

output "resource_group_name" {
  description = "Azure resource group name."
  value       = module.network.resource_group_name
}

output "oidc_issuer_url" {
  description = "OIDC issuer used by workload identity."
  value       = module.aks.oidc_issuer_url
}

