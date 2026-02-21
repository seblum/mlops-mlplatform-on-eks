output "azs" {
  description = "Availability zones"
  value       = module.vpc.azs
}

output "private_subnets" {
  description = "List of private subnets"
  value       = module.vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
  description = "List of CIDR blocks for private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "worker_group_mgmt_one_id" {
  description = "ID of the security group for worker group management one"
  value       = aws_security_group.worker_group_mgmt_one.id
}

output "worker_group_mgmt_two_id" {
  description = "ID of the security group for worker group management two"
  value       = aws_security_group.worker_group_mgmt_two.id
}
