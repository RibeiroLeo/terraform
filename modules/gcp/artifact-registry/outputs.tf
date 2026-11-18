output "docker_repository" {
  description = "Repository path to prefix Docker image names."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.this.repository_id}"
}
