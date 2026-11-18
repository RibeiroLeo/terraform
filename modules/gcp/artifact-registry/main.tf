resource "google_artifact_registry_repository" "this" {
  project       = var.project_id
  location      = var.region
  repository_id = var.repository_id
  format        = "DOCKER"
  description   = "Docker images for ${var.repository_id}"
  labels        = var.labels

  docker_config {
    immutable_tags = true
  }
}
