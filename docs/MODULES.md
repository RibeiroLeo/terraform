# Catálogo de módulos

| Módulo | Responsabilidade | Inputs essenciais | Outputs principais |
|---|---|---|---|
| `modules/aws/vpc` | VPC multi-AZ, subnets, IGW e NAT opcional | `name`, `availability_zones` | `vpc_id`, subnets públicas/privadas |
| `modules/aws/ecs-fargate` | Cluster, task, service, ALB, IAM, logs e scaling | VPC/subnets, `container_image` | URL, cluster, service |
| `modules/aws/eks` | EKS, nodes, KMS, IAM, logs e add-ons | `name`, subnets privadas | endpoint, OIDC, node role |
| `modules/azure/network` | Resource group, VNet e subnets especializadas | `name`, `location` | RG, VNet e subnet IDs |
| `modules/azure/container-apps` | Environment, app, identity, logs e ingress | RG, subnet, imagem | URL, app ID, principal ID |
| `modules/azure/aks` | AKS, VMSS pool, identity, policy e logs | RG, subnet | cluster, OIDC, principal ID |

## Padrão de consumo

Os módulos não configuram providers ou backends. O root module controla região,
autenticação e estado:

```hcl
module "network" {
  source = "../../modules/aws/vpc"

  name               = "portfolio-dev"
  availability_zones = ["us-east-1a", "us-east-1b"]
  tags               = local.common_tags
}
```

Para evoluir o canivete suíço, mantenha cada peça pequena, com `versions.tf`,
`variables.tf`, `main.tf`, `outputs.tf` e README. Novos módulos recomendados para
uma segunda etapa: ECR/ACR, RDS/PostgreSQL, Key Vault/Secrets Manager, DNS/TLS,
WAF, observabilidade e bootstrap de state.

