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

variable "container_image" {
  description = "Public or private OCI image. Pin a digest before production."
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "tags" {
  description = "Extra cost-allocation and ownership tags."
  type        = map(string)
  default     = {}
}

