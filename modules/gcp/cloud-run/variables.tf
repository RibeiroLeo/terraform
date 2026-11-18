variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Cloud Run service region."
  type        = string
}

variable "name" {
  description = "Cloud Run service and runtime service account name."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.name))
    error_message = "Use 6 to 30 lowercase letters, digits, or hyphens. Start with a letter and end with a letter or digit."
  }
}

variable "container_image" {
  description = "Published OCI image, preferably pinned by digest."
  type        = string
}

variable "container_port" {
  description = "HTTP port on which the container listens."
  type        = number
  default     = 8080

  validation {
    condition     = var.container_port >= 1 && var.container_port <= 65535 && var.container_port == floor(var.container_port)
    error_message = "container_port must be an integer between 1 and 65535."
  }
}

variable "max_instances" {
  description = "Maximum instances per revision; review quotas for the region."
  type        = number
  default     = 3

  validation {
    condition     = var.max_instances >= 1 && var.max_instances == floor(var.max_instances)
    error_message = "max_instances must be a positive integer."
  }
}

variable "invoker_members" {
  description = "IAM principals allowed to invoke the service, for example user:you@example.com."
  type        = set(string)
  default     = []

  validation {
    condition     = !contains(var.invoker_members, "allUsers") && !contains(var.invoker_members, "allAuthenticatedUsers")
    error_message = "Grant access to named principals instead of allUsers or allAuthenticatedUsers."
  }
}

variable "deletion_protection" {
  description = "Protect the service from accidental Terraform destruction."
  type        = bool
  default     = true
}

variable "labels" {
  description = "GCP resource labels for the service."
  type        = map(string)
  default     = {}
}
