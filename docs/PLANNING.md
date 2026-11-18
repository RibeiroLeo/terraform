# Runbook de planejamento

## 1. Autenticação local

AWS:

```bash
aws sso login --profile portfolio
export AWS_PROFILE=portfolio
aws sts get-caller-identity
```

Azure:

```bash
az login
az account set --subscription <subscription-id>
az account show --query '{name:name,id:id}'
export TF_VAR_subscription_id=<subscription-id>
```

No PowerShell, use `$env:AWS_PROFILE = "portfolio"` ou
`$env:TF_VAR_subscription_id = "..."`.

GCP usa Application Default Credentials para o plan autenticado. Consulte
[Preparar um plan autenticado no GCP](GCP.md#preparar-um-plan-autenticado).

## 2. Estado

Para validação local sem state remoto:

```bash
terraform init -backend=false
```

Para um plan compartilhado, crie previamente o backend, copie
`backend.tf.example` para `backend.tf`, copie e preencha `backend.hcl.example` e
rode:

```bash
terraform init -reconfigure -backend-config=backend.hcl
```

Os arquivos `backend.tf`, `backend.hcl`, `*.tfvars`, state e plans são ignorados
pelo Git.

## 3. Quality gate

```bash
terraform fmt -recursive -check
terraform validate
terraform test -verbose -no-color

# Apenas quando houver autenticação cloud:
terraform plan -refresh=false -out=tfplan
terraform show -no-color tfplan
```

Revise principalmente recursos destruídos/substituídos, acessos `0.0.0.0/0`,
IAM/RBAC, mudanças de rede, imagens e estimativa de custo. Nunca faça commit de
um `.tfplan`: ele pode conter valores sensíveis.

## 4. Seleção da stack

```bash
make validate STACK=aws-ecs
make offline-plan STACK=aws-ecs
make validate STACK=aws-eks
make validate STACK=azure-container-apps
make validate STACK=azure-aks
make offline-plan STACK=gcp-gke
make offline-plan STACK=gcp-cloud-run
```

O Makefile é conveniência para Linux/macOS/WSL. No Windows puro, use diretamente
os comandos `terraform -chdir=environments/<stack> ...`.
