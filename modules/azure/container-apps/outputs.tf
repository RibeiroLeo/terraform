output "application_url" {
  description = "HTTPS URL of the latest Container App revision."
  value       = "https://${azurerm_container_app.this.latest_revision_fqdn}"
}

output "container_app_id" {
  description = "Container App resource ID."
  value       = azurerm_container_app.this.id
}

output "identity_principal_id" {
  description = "Managed identity principal ID for downstream role assignments."
  value       = azurerm_user_assigned_identity.this.principal_id
}

