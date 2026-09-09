# GitHub Actions, OIDC e aprovação

## Quality gate

`terraform-ci.yml` não acessa contas cloud: baixa providers, valida as quatro
raízes e executa análise estática em todo pull request.

## Plan autenticado

1. Em **Settings > Environments**, crie `terraform-plan-approval`.
2. Adicione required reviewers. O job fica aguardando depois que o artefato do
   plan foi publicado; revise `plan.txt` antes de aprovar.
3. Em **Settings > Secrets and variables > Actions > Variables**, configure:
   - `AWS_ROLE_ARN` para uma role federada ao GitHub;
   - `AZURE_CLIENT_ID`, `AZURE_TENANT_ID` e `AZURE_SUBSCRIPTION_ID` para uma app
     registration/federated credential.
4. Restrinja os trust policies ao owner, repositório, branch e Environment.
5. Em **Actions > Terraform Plan > Run workflow**, selecione a stack.

O workflow pede um plano manualmente, autentica sem segredo estático, publica
`plan.txt` e só então aguarda a aprovação do Environment. Ele nunca executa
`apply`.

O workflow usa o backend local efêmero porque o objetivo é planejar a criação
completa. Para continuidade de state, copie `backend.tf.example` para
`backend.tf` e forneça a configuração do backend como variáveis protegidas do
Environment.
