variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Region for the subnet, router, and Cloud NAT."
  type        = string
}

variable "name" {
  description = "Prefix for network resources."
  type        = string
}

variable "subnet_cidr" {
  description = "Primary IPv4 range used by nodes."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.subnet_cidr))
    error_message = "subnet_cidr must be a valid IPv4 CIDR."
  }
}

variable "pods_cidr" {
  description = "Secondary IPv4 range used by Pods."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.pods_cidr))
    error_message = "pods_cidr must be a valid IPv4 CIDR."
  }
}

variable "services_cidr" {
  description = "Secondary IPv4 range used by Kubernetes Services."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.services_cidr))
    error_message = "services_cidr must be a valid IPv4 CIDR."
  }
}
