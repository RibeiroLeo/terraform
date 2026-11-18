# GKE Standard

Cria um control plane regional com endpoint privado e um node pool independente
com autoscaling. Os nós têm conta de serviço dedicada, Shielded VM,
Workload Identity Federation para GKE e atualização automática pelo canal
Regular. O Dataplane V2 oferece suporte a Kubernetes NetworkPolicy.

Use uma VPC nativa com sub-rede regional, faixas secundárias para Pods e Services
e saída para os nós privados. O módulo
[network](../network/README.md) entrega esses recursos. `node_zones` define
as zonas do pool. O exemplo usa uma zona para reduzir o custo inicial. Ajuste
`node_autoscaling` e selecione mais zonas para distribuir os nós.

O exemplo [gcp-gke](../../../environments/gcp-gke/main.tf) demonstra composição,
IAM e ativação de APIs. Os comandos para planejar e acessar o cluster estão no
[runbook GCP](../../../docs/GCP.md).
