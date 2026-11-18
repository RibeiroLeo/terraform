# Rede GCP

Cria uma VPC customizada, uma sub-rede com Private Google Access, duas faixas
secundárias para GKE e Cloud Router com Cloud NAT restrito à sub-rede. O NAT
fornece saída para nós e Pods sem exigir IP público nos nós.

Forneça `project_id`, `region`, `name` e CIDRs IPv4 distintos em `subnet_cidr`,
`pods_cidr` e `services_cidr`. Passe `network_id`, `subnetwork_id`,
`pods_range_name` e `services_range_name` ao módulo GKE. Veja a
[composição no ambiente gcp-gke](../../../environments/gcp-gke/main.tf).
