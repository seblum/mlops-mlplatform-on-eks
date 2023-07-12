
data "aws_caller_identity" "current" {}

resource "random_string" "random_prefix" {
  length  = 12
  upper   = false
  special = false
}


# INFRASTRUCTURE
module "vpc" {
  source       = "./infrastructure/vpc"
  cluster_name = local.cluster_name
  vpc_name     = local.vpc_name
}


module "eks" {
  source                      = "./infrastructure/eks"
  cluster_name                = local.cluster_name
  eks_cluster_version         = "1.23"
  vpc_id                      = module.vpc.vpc_id
  aws_region                  = var.aws_region
  private_subnets             = module.vpc.private_subnets
  azs                         = module.vpc.azs
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  security_group_id_one       = [module.vpc.worker_group_mgmt_one_id]
  security_group_id_two       = [module.vpc.worker_group_mgmt_two_id]
  # depends_on = [
  #   module.vpc
  # ]
  # if this is in, I get an for_each error. weird
}


module "user-profiles" {
  source = "./modules/user-profiles"
  #user_env           = var.user_env
  profiles = local.profiles_config
  # kfp_s3_bucket_name = module.kubeflow_components.s3_bucket_name
  # tags               = local.tags
  eks_oidc_provider = module.eks.oidc_provider_arn
}


# CUSTOM TOOLS

module "mlflow" {
  count                 = var.deploy_mlflow ? 1 : 0
  source                = "./modules/mlflow"
  name                  = "mlflow"
  namespace             = "mlflow"
  mlflow_s3_bucket_name = local.mlflow_s3_bucket_name
  s3_force_destroy      = local.force_destroy_s3_bucket
  oidc_provider_arn     = module.eks.oidc_provider_arn
  name_prefix = local.name_prefix
  # RDS
  vpc_id                      = module.vpc.vpc_id
  private_subnets             = module.vpc.private_subnets
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  rds_port                    = local.port_mlflow
  rds_name                    = "mlflow"
  rds_engine                  = "mysql"
  rds_engine_version          = "8.0.33"
  rds_instance_class          = "db.t3.micro"
  storage_type                = local.storage_type
  max_allocated_storage       = local.max_allocated_storage

  depends_on = [
    module.eks
  ]
}

module "airflow" {
  count                      = var.deploy_airflow ? 1 : 0
  source                     = "./modules/airflow"
  name                       = "airflow"
  namespace                  = "airflow"
  name_prefix                = local.name_prefix
  cluster_name               = local.cluster_name
  cluster_endpoint           = module.eks.cluster_endpoint
  oidc_provider_arn          = module.eks.oidc_provider_arn
  user_profiles              = local.airflow_profiles
  s3_data_bucket_secret_name = local.airflow_s3_data_bucket_credentials
  s3_data_bucket_name        = local.airflow_s3_data_bucket

  # RDS
  vpc_id                      = module.vpc.vpc_id
  private_subnets             = module.vpc.private_subnets
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  rds_port                    = local.port_airflow
  rds_name                    = "airflow"
  rds_engine                  = "postgres"
  rds_engine_version          = "13.11" # end of support may 2024
  rds_instance_class          = "db.t3.micro"
  storage_type                = local.storage_type
  max_allocated_storage       = local.max_allocated_storage
  # periodic updates
  # log airflow to s3

  # HELM
  helm_chart_repository = "https://airflow-helm.github.io/charts"
  helm_chart_name       = "airflow"
  helm_chart_version    = "8.7.1"
  git_username          = local.git_username
  git_token             = local.git_token
  git_repository_url    = local.git_repository_url
  git_branch            = local.git_branch
  mlflow_tracking_uri   = var.deploy_mlflow ? module.mlflow[0].mlflow_tracking_uri : ""

  depends_on = [
    module.eks,
    module.user-profiles
  ]
}

module "jupyterhub" {
  count            = var.deploy_jupyterhub ? 1 : 0
  source           = "./modules/jupyterhub"
  name             = "jupyterhub"
  cluster_name     = local.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint

  admin_user_list = local.jupyterhub_admin_user_list
  allowed_user_list = local.jupyterhub_allowed_user_list
  
  # # RDS
  # vpc_id                      = module.vpc.vpc_id
  # private_subnets             = module.vpc.private_subnets
  # private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  # rds_port                    = local.port_airflow
  # rds_name                    = "jupyterhub"
  # rds_engine                  = "postgres"
  # rds_engine_version          = "13.3"
  # rds_instance_class          = "db.t3.micro"
  # storage_type                = local.storage_type
  # max_allocated_storage       = local.max_allocated_storage
  # # periodic updates
  # # log airflow to s3

  # HELM
  helm_chart_repository = "https://jupyterhub.github.io/helm-chart/"
  helm_chart_name       = "jupyterhub"
  helm_chart_version    = "2.0.0"
  mlflow_tracking_uri   = var.deploy_mlflow ? module.mlflow[0].mlflow_tracking_uri : ""

  depends_on = [
    module.eks,
    module.user-profiles
  ]
}

module "monitoring" {
  count  = var.deploy_monitoring ? 1 : 0
  source = "./modules/monitoring"
  name   = "monitoring"
}
