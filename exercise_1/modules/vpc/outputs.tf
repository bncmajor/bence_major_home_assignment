output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = [aws_subnet.public["a"].id, aws_subnet.public["b"].id]
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = [aws_subnet.private["a"].id, aws_subnet.private["b"].id]
}
 
output "load_balancer_sg_id" {
  description = "Security group ID for load balancer"
  value       = aws_security_group.load_balancer_sg.id
}
 
output "app_server_sg_id" {
  description = "Security group ID for app servers"
  value       = aws_security_group.app_server_sg.id
}