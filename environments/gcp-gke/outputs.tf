output "cluster_name" {
  description = "GKE cluster name."
  value       = module.gke.cluster_name
}

output "private_endpoint" {
  description = "Private Kubernetes API endpoint."
  value       = module.gke.private_endpoint
}

output "node_pool_name" {
  description = "Managed node pool name."
  value       = module.gke.node_pool_name
}

output "workload_identity_pool" {
  description = "Workload Identity Federation pool for Kubernetes workloads."
  value       = module.gke.workload_identity_pool
}
