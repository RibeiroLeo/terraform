# Azure Kubernetes Service

Creates a monitored AKS cluster using Azure CNI Overlay, autoscaling system nodes,
Azure Policy, workload identity and OIDC. The module intentionally does not expose
raw kubeconfig data in Terraform state or outputs.
