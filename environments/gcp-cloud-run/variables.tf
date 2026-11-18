variable "project_id" {
  description = "Existing GCP project with billing enabled."
  type        = string
}

variable "name" {
  description = "Cloud Run service and runtime service account name."
  type        = string
  default     = "portfolio-run"
}

variable "region" {
  description = "GCP region of Cloud Run and Artifact Registry."
  type        = string
  default     = "us-central1"
}

variable "repository_id" {
  description = "Artifact Registry repository for custom container images."
  type        = string
  default     = "portfolio-docker"
}

variable "container_image" {
  description = "Published OCI image. Defaults to Google's Cloud Run sample."
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello:latest"
}

variable "container_port" {
  description = "HTTP port on which the container listens."
  type        = number
  default     = 8080
}

variable "max_instances" {
  description = "Maximum instances per revision."
  type        = number
  default     = 3
}

variable "invoker_members" {
  description = "IAM principals allowed to invoke the service."
  type        = set(string)
  default     = []
}

variable "deletion_protection" {
  description = "Protect the service from accidental Terraform destruction."
  type        = bool
  default     = true
}
