output "application_url" {
  description = "Public demo URL after apply."
  value       = module.service.application_url
}

output "cluster_name" {
  description = "ECS cluster name."
  value       = module.service.cluster_name
}

