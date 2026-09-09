variable "name" {
  description = "Service name and resource prefix."
  type        = string
}

variable "vpc_id" {
  description = "VPC where the service and load balancer are created."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets used by the internet-facing load balancer."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnets used by Fargate tasks."
  type        = list(string)
}

variable "container_image" {
  description = "OCI image reference. Pin a digest for production."
  type        = string
}

variable "container_port" {
  description = "Port exposed by the application container."
  type        = number
  default     = 80
}

variable "cpu" {
  description = "Fargate task CPU units."
  type        = number
  default     = 256
}

variable "memory" {
  description = "Fargate task memory in MiB."
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of running tasks."
  type        = number
  default     = 1
}

variable "health_check_path" {
  description = "HTTP path checked by the load balancer."
  type        = string
  default     = "/"
}

variable "environment" {
  description = "Non-secret environment variables passed to the container."
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "CloudWatch log retention."
  type        = number
  default     = 30
}

variable "enable_autoscaling" {
  description = "Enable target-tracking CPU autoscaling."
  type        = bool
  default     = true
}

variable "min_capacity" {
  description = "Autoscaling minimum task count."
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Autoscaling maximum task count."
  type        = number
  default     = 4
}

variable "tags" {
  description = "Additional tags applied to every resource."
  type        = map(string)
  default     = {}
}

