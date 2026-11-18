resource "google_project_service" "gke" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

module "network" {
  source = "../../modules/gcp/network"

  project_id    = var.project_id
  region        = var.region
  name          = var.name
  subnet_cidr   = var.subnet_cidr
  pods_cidr     = var.pods_cidr
  services_cidr = var.services_cidr

  depends_on = [google_project_service.gke["compute.googleapis.com"]]
}

module "gke" {
  source = "../../modules/gcp/gke"

  project_id          = var.project_id
  region              = var.region
  name                = var.name
  network_id          = module.network.network_id
  subnetwork_id       = module.network.subnetwork_id
  pods_range_name     = module.network.pods_range_name
  services_range_name = module.network.services_range_name
  control_plane_cidr  = var.control_plane_cidr
  authorized_networks = merge(var.admin_networks, { nodes = var.subnet_cidr })
  node_zones          = var.node_zones
  machine_type        = var.machine_type
  node_autoscaling    = var.node_autoscaling
  deletion_protection = var.deletion_protection
  labels              = { managed_by = "terraform", environment = "portfolio" }

  # Enable GKE APIs and provide egress before GKE provisions any nodes.
  depends_on = [google_project_service.gke, module.network]
}
