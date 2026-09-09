locals {
  name = "${var.project_name}-${var.environment}-aca"
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Repository  = "devops-multicloud-terraform"
  })
}

module "network" {
  source = "../../modules/azure/network"

  name                           = local.name
  location                       = var.location
  address_space                  = ["10.20.0.0/16"]
  container_apps_subnet_prefixes = ["10.20.0.0/23"]
  aks_subnet_prefixes            = ["10.20.4.0/22"]
  tags                           = local.common_tags
}

module "container_app" {
  source = "../../modules/azure/container-apps"

  name                     = local.name
  resource_group_name      = module.network.resource_group_name
  location                 = module.network.location
  infrastructure_subnet_id = module.network.container_apps_subnet_id
  container_image          = var.container_image
  container_port           = 80
  min_replicas             = 0
  max_replicas             = 3
  tags                     = local.common_tags
}

