variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Region of the GKE control plane."
  type        = string
}

variable "name" {
  description = "Cluster name and prefix of the node service account."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,22}[a-z0-9]$", var.name))
    error_message = "Use 2 to 24 lowercase letters, digits, or hyphens. Start with a letter and end with a letter or digit."
  }
}

variable "network_id" {
  description = "ID or self-link of the VPC."
  type        = string
}

variable "subnetwork_id" {
  description = "ID or self-link of the regional subnet."
  type        = string
}

variable "pods_range_name" {
  description = "Subnet secondary range name for Pod IPs."
  type        = string
}

variable "services_range_name" {
  description = "Subnet secondary range name for Service IPs."
  type        = string
}

variable "control_plane_cidr" {
  description = "Non-overlapping private IPv4 /28 allocated to the control plane."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.control_plane_cidr)) && endswith(var.control_plane_cidr, "/28")
    error_message = "control_plane_cidr must be an IPv4 /28."
  }
}

variable "authorized_networks" {
  description = "Named IPv4 CIDRs for administration through the private endpoint."
  type        = map(string)

  validation {
    condition = length(var.authorized_networks) > 0 && alltrue([
      for cidr in values(var.authorized_networks) : can(cidrnetmask(cidr)) && !endswith(cidr, "/0")
    ])
    error_message = "Provide at least one valid IPv4 CIDR. An unrestricted /0 range is not allowed."
  }
}

variable "node_zones" {
  description = "Zones for worker nodes. Use zones in the cluster region."
  type        = set(string)

  validation {
    condition     = length(var.node_zones) > 0
    error_message = "Provide at least one node zone."
  }
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

  validation {
    condition = (
      var.node_autoscaling.min >= 1 &&
      var.node_autoscaling.max >= var.node_autoscaling.min &&
      var.node_autoscaling.min == floor(var.node_autoscaling.min) &&
      var.node_autoscaling.max == floor(var.node_autoscaling.max)
    )
    error_message = "Node limits must be integers with 1 <= min <= max."
  }
}

variable "deletion_protection" {
  description = "Protect the cluster from accidental Terraform destruction."
  type        = bool
  default     = true
}

variable "labels" {
  description = "GCP resource labels for the cluster."
  type        = map(string)
  default     = {}
}
