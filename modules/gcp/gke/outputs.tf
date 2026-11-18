output "cluster_name" {
  description = "GKE cluster name."
  value       = google_container_cluster.this.name
}

output "private_endpoint" {
  description = "Private Kubernetes API endpoint."
  value       = google_container_cluster.this.private_cluster_config[0].private_endpoint
}

output "node_pool_name" {
  description = "Managed node pool name."
  value       = google_container_node_pool.this.name
}

output "workload_identity_pool" {
  description = "Workload Identity Federation pool for Kubernetes workloads."
  value       = "${var.project_id}.svc.id.goog"
}
