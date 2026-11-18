# Artifact Registry

Cria um repositório Docker regional com tags imutáveis. Forneça `project_id`,
`region` e `repository_id`. Use o output `docker_repository` como prefixo ao
taguear imagens para o `docker push`.

O exemplo [gcp-cloud-run](../../../environments/gcp-cloud-run/main.tf) ativa a
API do Artifact Registry. Siga o [runbook GCP](../../../docs/GCP.md#publicar-uma-imagem-docker-para-o-cloud-run)
para publicar uma imagem e usá-la no Cloud Run.
