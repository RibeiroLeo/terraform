# DevOps Multicloud Terraform Toolbox

[![Terraform CI](https://github.com/RibeiroLeo/terraform/actions/workflows/terraform-ci.yml/badge.svg)](https://github.com/RibeiroLeo/terraform/actions/workflows/terraform-ci.yml)

Portfólio de Infrastructure as Code para criar ambientes containerizados e
Kubernetes do zero no Google Cloud, na AWS e no Azure. A esteira vai até o plan
especulativo offline de cada stack.

## O que está pronto

| Stack | Runtime | Rede | Segurança e operação |
|---|---|---|---|
| `gcp-gke` | GKE Standard regional | VPC, nós privados, faixas de Pods e Services, Cloud NAT | Endpoint privado, Workload Identity Federation, Shielded VM e autoscaling |
| `gcp-cloud-run` | Cloud Run v2 + Artifact Registry | HTTPS gerenciado | IAM para invocação, conta de serviço dedicada e scale-to-zero |
| `aws-ecs` | ECS Fargate + ALB | VPC, 2 AZs, subnets públicas/privadas, NAT | IAM mínimo, SGs, logs, Container Insights, autoscaling |
| `aws-eks` | EKS + managed nodes | VPC, 2 AZs, nodes privados, NAT | KMS para Secrets, control-plane logs, add-ons e Spot configurável |
| `azure-container-apps` | Azure Container Apps | VNet e subnet delegada | Managed Identity, Log Analytics, HTTPS e scale-to-zero |
| `azure-aks` | AKS + VMSS | VNet e subnet dedicada | Entra/Azure RBAC, Workload Identity, Azure Policy e autoscaling |

O [guia GCP](docs/GCP.md) cobre os dois plans e a publicação da imagem Docker
de exemplo no Artifact Registry.

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
│   ├── azure-aks/
│   ├── gcp-gke/
│   └── gcp-cloud-run/
├── modules/                      # peças reutilizáveis
│   ├── aws/{vpc,ecs-fargate,eks}/
│   ├── azure/{network,container-apps,aks}/
│   └── gcp/{network,gke,artifact-registry,cloud-run}/
├── examples/cloud-run/           # Dockerfile e resposta HTTP de exemplo
├── docs/                         # arquitetura e runbooks
└── .github/workflows/            # qualidade, segurança e plan offline
```

Cada diretório em `environments/` tem provider, exemplos de backend e variáveis,
e outputs próprios. O isolamento de estado reduz o impacto de alterações entre
stacks.

## Início rápido

O plan offline requer Terraform `>= 1.8` e acesso ao registry dos providers.
O CI usa Terraform 1.17.2.

```bash
# Escolha uma das seis stacks
cd environments/gcp-gke

# Validação sem acessar o backend remoto
terraform init -backend=false
terraform fmt -check
terraform validate

# Mesmo plan offline usado pelo CI, sem login na cloud
terraform test -verbose -no-color
```

Para um plan real, copie `terraform.tfvars.example` para `terraform.tfvars`,
autentique na plataforma escolhida e use `terraform plan`. Os arquivos
`*.tfvars` ficam no ambiente local.

Para usar estado remoto, copie `backend.tf.example` para `backend.tf` e
`backend.hcl.example` para `backend.hcl`, ajuste os valores e execute
`terraform init -backend-config=backend.hcl`. O bucket S3, Storage Account ou
bucket Cloud Storage precisa existir antes. Consulte o [runbook de
planejamento](docs/PLANNING.md).

## Esteira CI

O workflow **Terraform CI** roda automaticamente em pull requests e pushes no
`master`, além de aceitar execução manual:

1. `terraform fmt -check`.
2. `terraform init -backend=false` e `terraform validate` nas seis stacks.
3. Scan de segurança IaC com Trivy.
4. `terraform test -verbose` com providers mockados, gerando um plan offline.
5. publicação de um `plan.txt` por stack por sete dias.

O plan offline valida o grafo, tipos, expressões e dependências sem acessar
AWS, Azure ou GCP. Login OIDC e confirmação humana estão comentados no workflow
para ativação futura.

Veja [como configurar OIDC e aprovações](docs/GITHUB_ACTIONS.md) e o [catálogo
dos módulos](docs/MODULES.md). A documentação de [aplicação
controlada](docs/DEPLOYMENT.md) existe apenas como runbook opcional; o CI não a
executa.

## Guardrails antes de um apply real

Os defaults priorizam uma demo fácil de revisar. Antes de produção:

1. mantenha os endpoints privados dos clusters ou, se habilitar acesso público,
   restrinja os CIDRs;
2. adicione conectividade VPN/bastion para administrar os clusters privados;
3. fixe imagens por digest e Kubernetes por versão suportada;
4. adicione HTTPS/ACM ao ALB do ECS;
5. revise quotas, regiões, disponibilidade zonal e custos;
6. execute o plan com identidade read-only/plan e aprove o resultado fora da
   identidade que faria o apply.

## Licença

[MIT](LICENSE)
