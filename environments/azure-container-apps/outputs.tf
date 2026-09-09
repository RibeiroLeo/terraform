output "application_url" {
  description = "Public demo URL after apply."
  value       = module.container_app.application_url
}

output "resource_group_name" {
  description = "Azure resource group name."
  value       = module.network.resource_group_name
}

