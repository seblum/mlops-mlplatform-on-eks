

module "vpc" {
  source  = "./modules/vpc"
  cluster_name = local.cluster_name
}

module "rds" {
  source = "./modules/rds"

  vpc = module.vpc
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

locals {
  cluster_name = "airflow-seblum-eks"
}



# resource "random_string" "suffix" {
#   length  = 8
#   special = false
# }