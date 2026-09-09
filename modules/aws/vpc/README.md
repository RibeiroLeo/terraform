# AWS VPC

Creates a multi-AZ VPC with public and private subnets, an internet gateway and an optional single NAT Gateway. Public/private subnets are tagged for Kubernetes load balancer discovery.

```hcl
module "network" {
  source             = "../../modules/aws/vpc"
  name               = "portfolio-dev"
  vpc_cidr           = "10.10.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
}
```

The single NAT design is intentionally cost-conscious. For production availability, extend the module to use one NAT Gateway per AZ.
