output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = values(aws_subnet.public)[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = values(aws_subnet.private)[*].id
}
 
output "load_balancer_sg_id" {
  description = "Security group ID for load balancer"
  value       = aws_security_group.load_balancer_sg.id
}
 
output "app_server_sg_id" {
  description = "Security group ID for app servers"
  value       = aws_security_group.app_server_sg.id
}