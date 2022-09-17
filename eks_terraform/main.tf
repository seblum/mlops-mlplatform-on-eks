
provider "aws" {
  region     = var.region
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY

}

locals {
  cluster_name = "airflow-seblum-eks"
}

module "eks" {
  source                = "./modules/eks"
  cluster_name          = local.cluster_name
  private_subnets       = module.vpc.private_subnets
  security_group_id_one = [module.vpc.worker_group_mgmt_one_id]
  security_group_id_two = [module.vpc.worker_group_mgmt_two_id]
  vpc_id                = module.vpc.vpc_id
  rds_password          = module.rds.rds_password
}

module "vpc" {
  source       = "./modules/vpc"
  cluster_name = local.cluster_name
}

module "rds" {
  source                      = "./modules/rds"
  vpc_private_subnets         = module.vpc.private_subnets
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  vpc_id                      = module.vpc.vpc_id
  # vpc                    = module.vpc
}

module "helm" {
  source                = "./modules/helm"
  cluster_name          = local.cluster_name
  cluster_endpoint      = module.eks.cluster_endpoint
  eks_cluster_authority = module.eks.kubeconfig_certificate_authority
}



# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 3.20.0"
#     }

#     random = {
#       source  = "hashicorp/random"
#       version = "3.1.0"
#     }

#     local = {
#       source  = "hashicorp/local"
#       version = "2.1.0"
#     }

#     null = {
#       source  = "hashicorp/null"
#       version = "3.1.0"
#     }

#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = ">= 2.0.1"
#     }
#   }

#   required_version = ">= 0.14"
# }
