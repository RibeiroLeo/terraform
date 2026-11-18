output "service_name" {
  description = "Cloud Run service name."
  value       = google_cloud_run_v2_service.this.name
}

output "service_url" {
  description = "HTTPS serving URL. Invocation requires IAM authorization."
  value       = google_cloud_run_v2_service.this.uri
}

output "runtime_service_account" {
  description = "Service account email for the running container."
  value       = google_service_account.runtime.email
}
