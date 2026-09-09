variable "name" {
  description = "Container App name and resource prefix."
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

variable "infrastructure_subnet_id" {
  description = "Dedicated delegated subnet used by the Container Apps environment."
  type        = string
}

variable "container_image" {
  description = "OCI image reference. Pin a digest for production."
  type        = string
}

variable "container_port" {
  description = "Container and ingress target port."
  type        = number
  default     = 80
}

variable "cpu" {
  description = "vCPU assigned to each replica."
  type        = number
  default     = 0.25
}

variable "memory" {
  description = "Memory assigned to each replica."
  type        = string
  default     = "0.5Gi"
}

variable "min_replicas" {
  description = "Minimum replicas. Zero enables scale-to-zero."
  type        = number
  default     = 0
}

variable "max_replicas" {
  description = "Maximum replicas."
  type        = number
  default     = 3
}

variable "environment" {
  description = "Non-secret environment variables passed to the container."
  type        = map(string)
  default     = {}
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

