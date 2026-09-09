locals {
  name = "${var.project_name}-${var.environment}-ecs"
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
  vpc_cidr           = "10.10.0.0/16"
  enable_nat_gateway = true
  tags               = local.common_tags
}

module "service" {
  source = "../../modules/aws/ecs-fargate"

  name               = local.name
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  container_image    = var.container_image
  container_port     = 80
  desired_count      = 1
  min_capacity       = 1
  max_capacity       = 3
  health_check_path  = "/"
  tags               = local.common_tags
}

