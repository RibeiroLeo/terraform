# GCP com Terraform

## Stacks

| Stack | Recursos | Saídas |
|---|---|---|
| `gcp-gke` | GKE Standard regional, pool autoscalável de nós privados, VPC, sub-rede com faixas para Pods e Services e Cloud NAT | Nome do cluster, endpoint privado, nome do pool e pool de Workload Identity |
| `gcp-cloud-run` | Serviço Cloud Run v2 com scale-to-zero, conta de serviço de execução e Artifact Registry Docker | Nome do serviço, URL HTTPS, caminho do registry e conta de serviço |

## Reproduzir o CI

Execute a partir da raiz do repositório com Terraform 1.17.2, a versão da
esteira. O `init` baixa o provider Google fixado nos lockfiles. O plan usa o
schema do provider e valores simulados.

```bash
make offline-plan STACK=gcp-gke
make offline-plan STACK=gcp-cloud-run
```

No PowerShell, escolha `gcp-gke` ou `gcp-cloud-run` em `$stack`.

```powershell
$stack = "gcp-gke"
terraform "-chdir=environments/$stack" init -backend=false -input=false
terraform "-chdir=environments/$stack" validate
terraform "-chdir=environments/$stack" test -verbose -no-color
```

Em **Actions → Terraform CI**, cada execução bem-sucedida publica um
`plan.txt` em `gcp-gke-offline-plan` e `gcp-cloud-run-offline-plan`.

## Preparar um plan autenticado

Use um projeto GCP existente com faturamento habilitado. A identidade responsável
pelo provisionamento precisa ter permissão para habilitar APIs e gerenciar os
recursos da stack. A Service Usage API, a Cloud Resource Manager API e a IAM API
devem estar habilitadas no projeto. Cada stack declara suas APIs de produto e
mantém essas APIs habilitadas ao remover a infraestrutura.

No Bash, autentique o Google Cloud CLI e obtenha Application Default Credentials
para o Terraform. Troque o valor de `PROJECT_ID` pelo ID do projeto.

```bash
PROJECT_ID="your-gcp-project-id"

gcloud auth login
gcloud auth application-default login
gcloud auth application-default set-quota-project "$PROJECT_ID"
```

Copie `terraform.tfvars.example` para `terraform.tfvars` na stack desejada,
preencha `project_id` e revise `region`. Se mudar a região do GKE, ajuste
`node_zones` e confira as faixas CIDR para evitar sobreposição com redes
conectadas. O cluster usa o canal Regular e a criação sem pool padrão requer
GKE `1.36.4-gke.1469000` ou posterior. Confira a versão padrão na região com
`gcloud container get-server-config --region us-central1 --project "$PROJECT_ID"`.
[Versões do canal Regular](https://docs.cloud.google.com/kubernetes-engine/docs/release-notes-regular).

Para usar estado compartilhado, configure um bucket Cloud Storage existente com
versionamento de objetos e copie os exemplos `backend.tf.example` e
`backend.hcl.example`. Cada stack usa um prefixo próprio. Consulte o
[runbook de planejamento](PLANNING.md#2-estado).

```bash
terraform -chdir=environments/gcp-gke init -input=false
terraform -chdir=environments/gcp-gke plan -input=false -out=gcp.tfplan
terraform -chdir=environments/gcp-gke show gcp.tfplan
```

Substitua `gcp-gke` por `gcp-cloud-run` para planejar o outro ambiente. Revise
o resultado antes de qualquer implantação. Um deploy de GKE pode gerar cobrança
por cluster, nós, discos e Cloud NAT. As duas stacks habilitam proteção contra
exclusão. Para remover um ambiente implantado, desabilite a proteção com uma
alteração revisada antes de gerar o plano de destruição.
[Runbook de aplicação controlada](DEPLOYMENT.md).

## Acessar o GKE após uma implantação

Rode o Google Cloud CLI, `kubectl` e `gke-gcloud-auth-plugin` de uma rede com
rota para o endpoint privado. O exemplo autoriza a faixa da sub-rede dos nós.
Para uma máquina de administração em outra sub-rede conectada na região, inclua
o CIDR de origem em `admin_networks`. A identidade precisa das permissões IAM e
RBAC correspondentes.

```bash
gcloud container clusters get-credentials portfolio-gke \
  --project "$PROJECT_ID" --region us-central1 --internal-ip
kubectl get nodes
```

## Publicar uma imagem Docker para o Cloud Run

Para a primeira implantação, a stack usa uma imagem de demonstração publicada pelo
Google e cria o registry no mesmo projeto. O serviço exige autenticação. Inclua
a conta que vai testar em `invoker_members` no arquivo de variáveis, por exemplo
`["user:you@example.com"]`.

Após a criação do registry, uma identidade com permissão de escrita no
repositório pode publicar o [Dockerfile de exemplo](../examples/cloud-run/Dockerfile).
A imagem serve JSON na porta 8080.

```bash
DOCKER_REPO=$(terraform -chdir=environments/gcp-cloud-run output -raw docker_repository)
gcloud auth configure-docker "${DOCKER_REPO%%/*}"
IMAGE="$DOCKER_REPO/demo:v1"

docker build --platform linux/amd64 -t "$IMAGE" examples/cloud-run
docker push "$IMAGE"
```

Preencha `container_image` com o valor de `IMAGE` em `terraform.tfvars` e gere
outro plan para revisar a nova revisão. O registry tem tags imutáveis. Use uma
nova tag por build ou referencie a imagem pelo digest.

Para testar a revisão implantada com uma identidade autorizada, inicie o proxy e
acesse `http://localhost:8080`.

```bash
gcloud run services proxy portfolio-run \
  --project "$PROJECT_ID" --region us-central1 --port 8080
```

[Contrato de execução de containers no Cloud Run](https://docs.cloud.google.com/run/docs/container-contract).
