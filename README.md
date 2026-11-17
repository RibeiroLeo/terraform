# DevOps Multicloud Terraform Toolbox

[![Terraform CI](https://github.com/RibeiroLeo/terraform/actions/workflows/terraform-ci.yml/badge.svg)](https://github.com/RibeiroLeo/terraform/actions/workflows/terraform-ci.yml)

Portfólio de Infrastructure as Code para criar ambientes containerizados e
Kubernetes do zero na AWS e no Azure. O CI gera automaticamente um plan
especulativo offline para cada stack; não existe workflow de `apply`.

## O que está pronto

| Stack | Runtime | Rede | Segurança e operação |
|---|---|---|---|
| `aws-ecs` | ECS Fargate + ALB | VPC, 2 AZs, subnets públicas/privadas, NAT | IAM mínimo, SGs, logs, Container Insights, autoscaling |
| `aws-eks` | EKS + managed nodes | VPC, 2 AZs, nodes privados, NAT | KMS para Secrets, control-plane logs, add-ons e Spot configurável |
| `azure-container-apps` | Azure Container Apps | VNet e subnet delegada | Managed Identity, Log Analytics, HTTPS e scale-to-zero |
| `azure-aks` | AKS + VMSS | VNet e subnet dedicada | Entra/Azure RBAC, Workload Identity, Azure Policy e autoscaling |

> `plan` não cria recursos nem gera cobrança de infraestrutura. Um futuro
> `apply` criaria NAT Gateway, load balancers e clusters gerenciados que têm
> custo mesmo com pouca carga.

## Arquitetura do repositório

```text
.
├── environments/                 # root modules e estados independentes
│   ├── aws-ecs/
│   ├── aws-eks/
│   ├── azure-container-apps/
│   └── azure-aks/
├── modules/                      # peças reutilizáveis
│   ├── aws/{vpc,ecs-fargate,eks}/
│   └── azure/{network,container-apps,aks}/
├── docs/                         # arquitetura e runbooks
└── .github/workflows/            # qualidade, segurança e plan offline
```

Cada diretório em `environments/` tem provider, backend, variáveis de exemplo e
outputs próprios. Isso limita blast radius e evita misturar estado AWS/Azure ou
Docker/Kubernetes.

## Início rápido

Pré-requisitos: Terraform `>= 1.8`, AWS CLI ou Azure CLI e uma identidade com as
permissões da plataforma escolhida.

```bash
# Escolha uma das quatro stacks
cd environments/aws-ecs

# Validação sem acessar o backend remoto
terraform init -backend=false
terraform fmt -check
terraform validate

# Mesmo plan offline usado pelo CI, sem login na cloud
terraform test -verbose -no-color
```

Para um plan real, copie `terraform.tfvars.example` para `terraform.tfvars`,
autentique na cloud e use `terraform plan`. Arquivos `*.tfvars` não são
commitados.

Para usar estado remoto, copie `backend.tf.example` para `backend.tf` e
`backend.hcl.example` para `backend.hcl`, ajuste os valores e execute
`terraform init -backend-config=backend.hcl`. O bucket S3 ou Storage Account
precisa existir antes. Consulte o [runbook de
planejamento](docs/PLANNING.md).

## Esteira CI

O workflow **Terraform CI** roda automaticamente em pull requests e pushes no
`master`, além de aceitar execução manual:

1. `terraform fmt -check`;
2. `terraform init -backend=false` e `terraform validate` nas quatro stacks;
3. scan de segurança IaC com Trivy;
4. `terraform test -verbose` com providers mockados, gerando um plan offline;
5. publicação de um `plan.txt` por stack por sete dias.

O plan offline valida o grafo, tipos, expressões e dependências sem acessar
AWS/Azure. Login OIDC e confirmação humana estão documentados e comentados no
workflow para ativação futura. Não há credenciais estáticas nem workflow de
`apply`.

Veja [como configurar OIDC e aprovações](docs/GITHUB_ACTIONS.md) e o [catálogo
dos módulos](docs/MODULES.md). A documentação de [aplicação
controlada](docs/DEPLOYMENT.md) existe apenas como runbook opcional; o CI não a
executa.

## Guardrails antes de um apply real

Os defaults priorizam uma demo fácil de revisar. Antes de produção:

1. mantenha os endpoints privados de EKS/AKS ou, se habilitar acesso público,
   restrinja os CIDRs;
2. adicione conectividade VPN/bastion para administrar os clusters privados;
3. fixe imagens por digest e Kubernetes por versão suportada;
4. adicione HTTPS/ACM ao ALB do ECS;
5. revise quotas, regiões, disponibilidade zonal e custos;
6. execute o plan com identidade read-only/plan e aprove o resultado fora da
   identidade que faria o apply.

## Licença

[MIT](LICENSE)
