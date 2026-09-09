variable "name" {
  description = "EKS cluster name and resource prefix."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs used by the control plane and nodes."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "EKS requires subnets in at least two availability zones."
  }
}

variable "kubernetes_version" {
  description = "Optional Kubernetes minor version. Null lets EKS choose its current default."
  type        = string
  default     = null
}

variable "node_instance_types" {
  description = "Allowed EC2 instance types for the managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_capacity_type" {
  description = "ON_DEMAND or SPOT capacity."
  type        = string
  default     = "SPOT"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.node_capacity_type)
    error_message = "node_capacity_type must be ON_DEMAND or SPOT."
  }
}

variable "node_min_size" {
  type        = number
  description = "Minimum managed node count."
  default     = 1
}

variable "node_desired_size" {
  type        = number
  description = "Initial managed node count."
  default     = 2
}

variable "node_max_size" {
  type        = number
  description = "Maximum managed node count."
  default     = 4
}

variable "endpoint_public_access" {
  description = "Expose the Kubernetes API publicly. Restrict public_access_cidrs when enabled."
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDRs allowed to reach the public Kubernetes API endpoint."
  type        = list(string)
  default     = ["192.0.2.0/24"]
}

variable "log_retention_days" {
  description = "Control-plane CloudWatch log retention."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Additional tags applied to every resource."
  type        = map(string)
  default     = {}
}
