locals {
  name = "${var.project_name}-${var.environment}"
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Repository  = "devops-multicloud-terraform"
  })
}

module "network" {
  source = "../../modules/azure/network"

  name                           = "${local.name}-aks"
  location                       = var.location
  address_space                  = ["10.21.0.0/16"]
  container_apps_subnet_prefixes = ["10.21.0.0/23"]
  aks_subnet_prefixes            = ["10.21.4.0/22"]
  tags                           = local.common_tags
}

module "aks" {
  source = "../../modules/azure/aks"

  name                    = local.name
  resource_group_name     = module.network.resource_group_name
  location                = module.network.location
  subnet_id               = module.network.aks_subnet_id
  kubernetes_version      = var.kubernetes_version
  vm_size                 = "Standard_D2s_v5"
  min_count               = 1
  max_count               = 3
  admin_group_object_ids  = var.admin_group_object_ids
  private_cluster_enabled = false
  tags                    = local.common_tags
}

