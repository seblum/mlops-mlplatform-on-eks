output "private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "worker_group_mgmt_one_id" {
  value = aws_security_group.worker_group_mgmt_one.id
}

output "worker_group_mgmt_two_id" {
  value = aws_security_group.worker_group_mgmt_two.id
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}
