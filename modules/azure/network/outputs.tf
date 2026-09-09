output "resource_group_name" {
  description = "Resource group name."
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "Resource group ID."
  value       = azurerm_resource_group.this.id
}

output "location" {
  description = "Azure region."
  value       = azurerm_resource_group.this.location
}

output "virtual_network_id" {
  description = "Virtual network ID."
  value       = azurerm_virtual_network.this.id
}

output "container_apps_subnet_id" {
  description = "Container Apps infrastructure subnet ID."
  value       = azurerm_subnet.container_apps.id
}

output "aks_subnet_id" {
  description = "AKS node subnet ID."
  value       = azurerm_subnet.aks.id
}

