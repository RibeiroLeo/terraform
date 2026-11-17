variable "name" {
  description = "AKS cluster name and resource prefix."
  type        = string
}

variable "resource_group_name" {
  description = "Existing resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "subnet_id" {
  description = "Existing subnet used by AKS nodes."
  type        = string
}

variable "kubernetes_version" {
  description = "Optional Kubernetes version. Null lets AKS select its current default."
  type        = string
  default     = null
}

variable "vm_size" {
  description = "System node pool VM size."
  type        = string
  default     = "Standard_D2s_v5"
}

variable "min_count" {
  description = "Minimum system node count."
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Maximum system node count."
  type        = number
  default     = 3
}

variable "admin_group_object_ids" {
  description = "Microsoft Entra group object IDs granted AKS admin access. Empty leaves Azure RBAC assignments to the caller."
  type        = list(string)
  default     = []
}

variable "private_cluster_enabled" {
  description = "Use a private Kubernetes API endpoint. Requires private network access for kubectl."
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Log Analytics retention in days."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Additional tags applied to every resource."
  type        = map(string)
  default     = {}
}

