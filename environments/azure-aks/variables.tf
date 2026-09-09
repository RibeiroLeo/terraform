variable "subscription_id" {
  description = "Azure subscription ID. Prefer TF_VAR_subscription_id or a non-committed tfvars file."
  type        = string
}

variable "project_name" {
  description = "Short lowercase project identifier."
  type        = string
  default     = "devops-portfolio"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name may contain only lowercase letters, numbers and hyphens."
  }
}

variable "environment" {
  description = "Deployment stage."
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "Brazil South"
}

variable "kubernetes_version" {
  description = "Optional AKS Kubernetes version."
  type        = string
  default     = null
}

variable "admin_group_object_ids" {
  description = "Microsoft Entra group object IDs granted cluster admin via Azure RBAC."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Extra cost-allocation and ownership tags."
  type        = map(string)
  default     = {}
}

