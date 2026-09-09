locals {
  name = "${var.project_name}-${var.environment}-eks"
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Repository  = "devops-multicloud-terraform"
  })
}

module "network" {
  source = "../../modules/aws/vpc"

  name               = local.name
  availability_zones = var.availability_zones
  vpc_cidr           = "10.11.0.0/16"
  enable_nat_gateway = true
  tags               = local.common_tags
}

module "eks" {
  source = "../../modules/aws/eks"

  name                   = local.name
  subnet_ids             = module.network.private_subnet_ids
  kubernetes_version     = var.kubernetes_version
  node_instance_types    = ["t3.medium"]
  node_capacity_type     = "SPOT"
  node_min_size          = 1
  node_desired_size      = 2
  node_max_size          = 4
  endpoint_public_access = true
  public_access_cidrs    = var.allowed_api_cidrs
  tags                   = local.common_tags
}

check "api_not_open_to_world" {
  assert {
    condition     = !contains(var.allowed_api_cidrs, "0.0.0.0/0")
    error_message = "For deployment, replace 0.0.0.0/0 with your trusted public CIDR."
  }
}

