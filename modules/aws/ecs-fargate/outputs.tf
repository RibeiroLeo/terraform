output "cluster_arn" {
  description = "ECS cluster ARN."
  value       = aws_ecs_cluster.this.arn
}

output "cluster_name" {
  description = "ECS cluster name."
  value       = aws_ecs_cluster.this.name
}

output "service_name" {
  description = "ECS service name."
  value       = aws_ecs_service.this.name
}

output "application_url" {
  description = "Public HTTP endpoint. Add ACM and an HTTPS listener before production use."
  value       = "http://${aws_lb.this.dns_name}"
}
