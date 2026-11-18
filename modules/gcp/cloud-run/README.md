# Cloud Run

Cria um serviço Cloud Run v2 que serve uma imagem OCI via HTTPS, com conta de
serviço dedicada e scale-to-zero. `invoker_members` define os usuários, grupos e
contas de serviço autorizados a invocar o endpoint. A identidade do container
pode receber permissões específicas caso a aplicação chame APIs GCP.

Forneça `project_id`, `region`, `name` e `container_image`. Ajuste
`container_port` para a porta HTTP da imagem, com padrão 8080.

Veja a composição no [ambiente gcp-cloud-run](../../../environments/gcp-cloud-run/main.tf)
e o [runbook de publicação Docker](../../../docs/GCP.md#publicar-uma-imagem-docker-para-o-cloud-run).
