output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "azs" {
  value = module.vpc.azs
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "worker_group_mgmt_one_id" {
  value = module.vpc.worker_group_mgmt_one_id
}

output "worker_group_mgmt_two_id" {
  value = module.vpc.worker_group_mgmt_two_id
}
