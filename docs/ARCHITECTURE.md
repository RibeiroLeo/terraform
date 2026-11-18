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

## GCP: container Docker

```mermaid
flowchart LR
  Client[Cliente autenticado] -->|HTTPS| Run[Cloud Run v2]
  Registry[Artifact Registry] -->|Imagem OCI| Run
  Runtime[Conta de serviço dedicada] -->|Identidade de execução| Run
```

O serviço exige IAM para invocação. A stack cria um registry para imagens
próprias e usa a imagem de exemplo do Google na primeira implantação.

## GCP: Kubernetes

```mermaid
flowchart LR
  Admin[Administração na rede privada] --> API[Control plane regional do GKE]
  API --> Nodes[Pool autoscalável de nós privados]
  subgraph VPC
    Nodes --> NAT[Cloud NAT]
    Nodes --> Ranges[Faixas de Pods e Services]
  end
```

Os nós usam Workload Identity Federation para workloads e uma conta de
serviço dedicada para operações do GKE. O padrão usa nós em uma zona, com
opção de distribuí-los em mais zonas da região.

## Decisões

- ECS Fargate, Azure Container Apps e Cloud Run representam o caminho Docker
  com execução gerenciada.
- EKS, AKS e GKE cobrem os ambientes Kubernetes.
- Um NAT compartilhado reduz o custo do laboratório; produção pode adotar um
  NAT por AZ para remover esse ponto único de falha.
- O lockfile de cada ambiente fixa a versão do provider testada pelo CI.

