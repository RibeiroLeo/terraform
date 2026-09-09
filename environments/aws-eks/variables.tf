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

variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "Two or more availability zones in aws_region."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "kubernetes_version" {
  description = "Optional EKS Kubernetes minor version."
  type        = string
  default     = null
}

variable "allowed_api_cidrs" {
  description = "Networks allowed to access the public Kubernetes API. Replace the default before apply."
  type        = list(string)
  default     = ["192.0.2.0/24"]
}

variable "tags" {
  description = "Extra cost-allocation and ownership tags."
  type        = map(string)
  default     = {}
}
