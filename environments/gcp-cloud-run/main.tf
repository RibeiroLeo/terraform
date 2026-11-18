locals {
  labels = { managed_by = "terraform", environment = "portfolio" }
}

resource "google_project_service" "cloud_run" {
  for_each = toset([
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

module "registry" {
  source = "../../modules/gcp/artifact-registry"

  project_id    = var.project_id
  region        = var.region
  repository_id = var.repository_id
  labels        = local.labels

  depends_on = [google_project_service.cloud_run["artifactregistry.googleapis.com"]]
}

module "cloud_run" {
  source = "../../modules/gcp/cloud-run"

  project_id          = var.project_id
  region              = var.region
  name                = var.name
  container_image     = var.container_image
  container_port      = var.container_port
  max_instances       = var.max_instances
  invoker_members     = var.invoker_members
  deletion_protection = var.deletion_protection
  labels              = local.labels

  depends_on = [google_project_service.cloud_run["run.googleapis.com"]]
}
