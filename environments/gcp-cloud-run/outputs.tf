output "service_name" {
  description = "Cloud Run service name."
  value       = module.cloud_run.service_name
}

output "service_url" {
  description = "HTTPS serving URL. Invocation requires IAM authorization."
  value       = module.cloud_run.service_url
}

output "docker_repository" {
  description = "Artifact Registry repository path for Docker image tags."
  value       = module.registry.docker_repository
}

output "runtime_service_account" {
  description = "Service account email for the running container."
  value       = module.cloud_run.runtime_service_account
}
