output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs ordered by availability zone."
  value       = [for az in var.availability_zones : aws_subnet.public[az].id]
}

output "private_subnet_ids" {
  description = "Private subnet IDs ordered by availability zone."
  value       = [for az in var.availability_zones : aws_subnet.private[az].id]
}

output "nat_gateway_id" {
  description = "NAT Gateway ID, or null when disabled."
  value       = try(aws_nat_gateway.this[0].id, null)
}

