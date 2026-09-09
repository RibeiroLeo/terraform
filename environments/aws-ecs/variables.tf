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

variable "container_image" {
  description = "Public or private OCI image. Pin a digest before production."
  type        = string
  default     = "public.ecr.aws/nginx/nginx:stable-alpine"
}

variable "tags" {
  description = "Extra cost-allocation and ownership tags."
  type        = map(string)
  default     = {}
}

