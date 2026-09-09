variable "name" {
  description = "Resource group and virtual network name prefix."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "Brazil South"
}

variable "address_space" {
  description = "Virtual network address spaces."
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "container_apps_subnet_prefixes" {
  description = "Dedicated Container Apps infrastructure subnet. /23 or larger is recommended."
  type        = list(string)
  default     = ["10.20.0.0/23"]
}

variable "aks_subnet_prefixes" {
  description = "Dedicated AKS node subnet."
  type        = list(string)
  default     = ["10.20.4.0/22"]
}

variable "tags" {
  description = "Additional tags applied to every resource."
  type        = map(string)
  default     = {}
}

