
locals {
  cluster_name            = "${var.name_prefix}-eks"
  vpc_name                = "${var.name_prefix}-vpc"
  port_airflow            = var.port_airflow
  port_mlflow             = var.port_mlflow
  mlflow_s3_bucket_name   = "${var.name_prefix}-mlflow-bucket"
  force_destroy_s3_bucket = true
  storage_type            = "gp2"
  max_allocated_storage   = var.max_allocated_storage
  airflow_github_ssh      = var.airflow_github_ssh
  git_username            = var.git_username
  git_token               = var.git_token
}

data "aws_caller_identity" "current" {
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
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
  eks_cluster_version   = "1.23"
}


# MODULES
module "airflow" {
  source                = "./modules/airflow"
  tag_name              = "airflow"
  cluster_name          = local.cluster_name
  cluster_endpoint      = data.aws_eks_cluster.cluster.endpoint
  eks_cluster_authority = data.aws_eks_cluster.cluster.certificate_authority.0.data
  airflow_github_ssh    = local.airflow_github_ssh # TODO delete

  # RDS
  vpc_id                      = module.vpc.vpc_id
  private_subnets             = module.vpc.private_subnets
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  rds_port                    = local.port_airflow
  rds_name                    = "airflow"
  rds_engine                  = "postgres"
  rds_engine_version          = "13.3"
  parameter_group_name        = "default.postgres13"
  rds_instance_class          = "db.t3.micro"
  storage_type                = local.storage_type
  max_allocated_storage       = local.max_allocated_storage

  # HELM
  helm_chart_repository = "https://airflow-helm.github.io/charts"
  helm_chart_name       = "airflow"
  helm_chart_version    = "8.6.1"
  git_username          = local.git_username
  git_token             = local.git_token
}


module "mlflow" {
  source = "./modules/mlflow"
  # account_id            = data.aws_caller_identity.current.account_id
  mlflow_s3_bucket_name = local.mlflow_s3_bucket_name
  s3_force_destroy      = local.force_destroy_s3_bucket

  # RDS
  vpc_id                      = module.vpc.vpc_id
  private_subnets             = module.vpc.private_subnets
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  rds_port                    = local.port_mlflow
  rds_name                    = "mlflow"
  rds_engine                  = "postgres"
  rds_engine_version          = "13.3"
  parameter_group_name        = "default.postgres13"
  rds_instance_class          = "db.t3.micro"
  storage_type                = local.storage_type
  max_allocated_storage       = local.max_allocated_storage
}
