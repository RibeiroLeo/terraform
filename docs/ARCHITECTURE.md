# Arquitetura

## AWS: container Docker

```mermaid
flowchart LR
  Internet --> ALB[Application Load Balancer]
  subgraph VPC
    subgraph Public[Subnets públicas / 2 AZs]
      ALB
      NAT[NAT Gateway]
    end
    subgraph Private[Subnets privadas / 2 AZs]
      ECS[ECS Fargate tasks]
    end
    ECS --> Logs[CloudWatch Logs]
    ECS --> NAT
  end
  ALB --> ECS
```

O load balancer é o único ponto de entrada. Tasks não recebem IP público e o
security group aceita tráfego apenas do ALB.

## AWS: Kubernetes

```mermaid
flowchart LR
  API[EKS control plane] --> Nodes[Managed node group]
  subgraph Private[Subnets privadas em 2 AZs]
    Nodes
  end
  Nodes --> NAT[NAT Gateway]
  API --> CW[Control-plane logs]
  KMS[KMS key] --> API
```

O cluster usa criptografia KMS para Secrets, logs de todos os componentes do
control plane, nodes privados e endpoint privado por padrão. Para habilitar o
endpoint público, forneça somente CIDRs confiáveis.

## Azure: container Docker

```mermaid
flowchart LR
  Internet --> Ingress[Container Apps HTTPS ingress]
  subgraph VNet
    ACA[Container Apps Environment]
    App[Container App / revisions]
    ACA --> App
  end
  App --> LAW[Log Analytics]
  ID[User Assigned Identity] --> App
```

O runtime serverless suporta scale-to-zero e usa identidade gerenciada, sem
segredo estático no código.

## Azure: Kubernetes

```mermaid
flowchart LR
  API[AKS control plane] --> Pool[Autoscaling VMSS pool]
  subgraph VNet
    Pool
  end
  Entra[Microsoft Entra ID] --> API
  WI[OIDC / Workload Identity] --> API
  API --> LAW[Log Analytics]
  Policy[Azure Policy] --> API
```

Azure RBAC, OIDC e Workload Identity são habilitados. A API é privada por padrão
e exige conectividade com a VNet para uso do `kubectl`.

## Decisões

- ECS Fargate e Azure Container Apps representam o caminho Docker sem operação
  de VMs.
- EKS e AKS cobrem os ambientes Kubernetes solicitados.
- Um NAT compartilhado reduz o custo do laboratório; produção pode adotar um
  NAT por AZ para remover esse ponto único de falha.
- Os providers aceitam apenas a próxima major abaixo de `7.0`/`6.0`; o lockfile
  criado por `terraform init` fixa a versão efetivamente testada.

