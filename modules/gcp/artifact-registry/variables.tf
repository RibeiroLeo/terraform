variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Region of the Docker repository."
  type        = string
}

variable "repository_id" {
  description = "Name of the Artifact Registry repository."
  type        = string
}

variable "labels" {
  description = "GCP resource labels for the repository."
  type        = map(string)
  default     = {}
}
