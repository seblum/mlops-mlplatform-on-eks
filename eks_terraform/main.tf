
locals {
  cluster_name            = "${var.name_prefix}-eks"
  vpc_name                = "${var.name_prefix}-vpc"
  port_airflow            = 5432
  port_mlflow             = 5000
  mlflow_s3_bucket_name   = "mlflow"
  force_destroy_s3_bucket = true
  storage_type            = "gp2"
  max_allocated_storage   = var.max_allocated_storage
  airflow_github_ssh      = var.AIRFLOW_GITHUB_SSH
}

data "aws_caller_identity" "current" {
}
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}


# INFRASTRUCTURE
module "vpc" {
  source       = "./infrastructure/vpc"
  cluster_name = local.cluster_name
  vpc_name     = local.vpc_name
}

module "eks" {
  source                = "./infrastructure/eks"
  cluster_name          = local.cluster_name
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  security_group_id_one = [module.vpc.worker_group_mgmt_one_id]
  security_group_id_two = [module.vpc.worker_group_mgmt_two_id]
}


# MODULES
module "airflow" {
  source                = "./modules/airflow"
  tag_name              = "airflow"
  cluster_name          = local.cluster_name
  cluster_endpoint      = data.aws_eks_cluster.cluster.endpoint
  eks_cluster_authority = data.aws_eks_cluster.cluster.certificate_authority.0.data
  storage_type          = local.storage_type
  max_allocated_storage = local.max_allocated_storage
  rds_password          = ""
  github_ssh            = local.airflow_github_ssh

  # RDS
  private_subnets             = module.vpc.private_subnets
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  vpc_id                      = module.vpc.vpc_id
  rds_port                    = local.port_airflow
  rds_name                    = "airflow"
  rds_engine                  = "postgres"
  rds_engine_version          = "13.3"

  # HELM
  helm_chart_repository = "https://airflow-helm.github.io/charts"
  helm_chart_name       = "airflow"
  helm_chart_version    = "8.6.1"
}

module "mlflow" {
  source                = "./modules/mlflow"
  account_id            = data.aws_caller_identity.current.account_id
  mlflow_s3_bucket_name = local.mlflow_s3_bucket_name
  s3_force_destroy      = local.force_destroy_s3_bucket
  storage_type          = local.storage_type

  # RDS
  private_subnets             = module.vpc.private_subnets
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  vpc_id                      = module.vpc.vpc_id
  rds_port                    = local.port_mlflow
  rds_name                    = "mlflow"
  rds_engine                  = "postgres"
  rds_engine_version          = "13.3"
}
