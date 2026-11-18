output "network_id" {
  description = "ID of the custom VPC."
  value       = google_compute_network.this.id
}

output "subnetwork_id" {
  description = "ID of the private GKE subnetwork."
  value       = google_compute_subnetwork.this.id
}

output "pods_range_name" {
  description = "Name of the secondary subnet range allocated to Pods."
  value       = "${var.name}-pods"
}

output "services_range_name" {
  description = "Name of the secondary subnet range allocated to Kubernetes Services."
  value       = "${var.name}-services"
}
