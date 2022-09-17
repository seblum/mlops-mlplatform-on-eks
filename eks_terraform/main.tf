module "eks" {
  source                = "./modules/eks"
  private_subnets       = module.vpc.private_subnets
  security_group_id_one = [module.vpc.worker_group_mgmt_one_id]
  security_group_id_two = [module.vpc.worker_group_mgmt_two_id]

}

module "vpc" {
  source = "./modules/vpc"

  cluster_name = local.cluster_name
}

module "rds" {
  source = "./modules/rds"

  vpc                    = module.vpc
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

locals {
  cluster_name = "airflow-seblum-eks"
}

module "helm" {
  source = "./modules/helm"
}

# resource "random_string" "suffix" {
#   length  = 8
#   special = false
# }
