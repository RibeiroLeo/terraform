# GitHub Actions: plan sem credenciais

## Pipeline ativa

`.github/workflows/terraform-ci.yml` roda em pull requests, pushes no branch
`master` e por acionamento manual. Os jobs seguem esta ordem:

```text
Format ──> Validate (6 stacks) ──> Offline plan (6 stacks)
       └─> Security ──────────────┘
```

Cada plan usa um `mock_provider` nativo do Terraform, definido em
`environments/<stack>/tests/ci_plan.tftest.hcl`. Assim, `terraform test` executa
um `command = plan` completo sem pedir token, consultar APIs ou criar recursos.

O resultado de cada stack fica disponível no run como artefato
`<stack>-offline-plan` por sete dias. `set -o pipefail` garante que o job falhe
mesmo com a saída passando por `tee`.

## O que esse plan garante

- configuração e sintaxe válidas;
- compatibilidade com o schema do provider baixado pelo lockfile;
- avaliação de tipos, expressões, dependências, checks e lifecycle;
- construção do grafo de recursos das seis stacks.

Ele não valida permissões IAM/RBAC, quotas, SKUs disponíveis na região, drift,
estado remoto ou respostas reais das APIs. Por isso o artefato é chamado de
**offline speculative plan**, e não de plan de implantação.

## Ativação futura de OIDC

Os blocos de login AWS, Azure e GCP, a permissão `id-token: write` e o job de
aprovação estão comentados no próprio workflow. Quando existirem contas sandbox:

1. configure as identidades federadas com condições para o repositório e a
   branch autorizados. No GCP, use um provider de Workload Identity Federation
   com impersonação de uma conta de serviço;
2. configure `AWS_ROLE_ARN`, `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`,
   `AZURE_SUBSCRIPTION_ID`, `GCP_PROJECT_ID`, `GCP_WORKLOAD_IDENTITY_PROVIDER`
   e `GCP_SERVICE_ACCOUNT` para as plataformas que serão autenticadas.
   Para um plan real no GCP, passe `GCP_PROJECT_ID` também como
   `TF_VAR_project_id`;
3. habilite `id-token: write` e os passos de login correspondentes;
4. troque o teste mockado por `terraform plan` autenticado com backend remoto;
5. crie o Environment `terraform-plan-approval` com required reviewers e
   habilite o job de confirmação somente após o plan real ser publicado.

Não habilite `apply` automaticamente junto com essa mudança. O princípio é
separar geração/revisão do plan da identidade autorizada a aplicar.
