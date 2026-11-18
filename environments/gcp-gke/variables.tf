variable "project_id" {
  description = "Existing GCP project with billing enabled."
  type        = string
}

variable "name" {
  description = "Name of the GKE cluster and prefix of its network."
  type        = string
  default     = "portfolio-gke"
}

variable "region" {
  description = "GCP region of the control plane and VPC subnet."
  type        = string
  default     = "us-central1"
}

variable "node_zones" {
  description = "Zones for worker nodes inside region."
  type        = set(string)
  default     = ["us-central1-a"]
}

variable "subnet_cidr" {
  description = "Primary IPv4 range for nodes."
  type        = string
  default     = "10.30.0.0/20"
}

variable "pods_cidr" {
  description = "Secondary IPv4 range for Pods."
  type        = string
  default     = "10.32.0.0/16"
}

variable "services_cidr" {
  description = "Secondary IPv4 range for Kubernetes Services."
  type        = string
  default     = "10.31.0.0/20"
}

variable "control_plane_cidr" {
  description = "Non-overlapping private IPv4 /28 for the control plane."
  type        = string
  default     = "10.33.0.0/28"
}

variable "admin_networks" {
  description = "Additional named IPv4 CIDRs that can reach the private GKE endpoint."
  type        = map(string)
  default     = {}
}

variable "machine_type" {
  description = "Compute Engine machine type for the node pool."
  type        = string
  default     = "e2-standard-2"
}

variable "node_autoscaling" {
  description = "Minimum and maximum total node counts across zones."
  type = object({
    min = number
    max = number
  })
  default = {
    min = 1
    max = 3
  }
}

variable "deletion_protection" {
  description = "Protect the cluster from accidental Terraform destruction."
  type        = bool
  default     = true
}
