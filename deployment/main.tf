data "aws_caller_identity" "current" {}
data "aws_region" "current" {} # 


# INFRASTRUCTURE
module "vpc" {
  source       = "./infrastructure/vpc"
  cluster_name = local.cluster_name
  vpc_name     = local.vpc_name
}


module "eks" {
  source                      = "./infrastructure/eks"
  cluster_name                = local.cluster_name
  eks_cluster_version         = "1.24"
  vpc_id                      = module.vpc.vpc_id
  aws_region                  = local.aws_region
  private_subnets             = module.vpc.private_subnets
  azs                         = module.vpc.azs
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  security_group_id_one       = [module.vpc.worker_group_mgmt_one_id]
  security_group_id_two       = [module.vpc.worker_group_mgmt_two_id]

  aws_auth_users_list = local.developers_user_access_auth_list
  # depends_on = [
  #   module.vpc
  # ]
  # if this is in, I get an for_each error. weird
}


module "networking" {
  source                  = "./infrastructure/networking"
  namespace               = "kube-system"
  cluster_name            = local.cluster_name
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  domain_name             = var.domain_name
}


module "user-profiles" {
  source            = "./modules/user-profiles"
  profiles          = local.profiles_config
  eks_oidc_provider = module.eks.oidc_provider_arn
}


# CUSTOM TOOLS

module "mlflow" {
  count             = var.deploy_mlflow ? 1 : 0
  source            = "./modules/mlflow"
  name              = "mlflow"
  namespace         = "mlflow"
  s3_bucket_name    = local.mlflow_s3_bucket_name
  s3_force_destroy  = local.force_destroy_s3_bucket
  oidc_provider_arn = module.eks.oidc_provider_arn
  name_prefix       = local.name_prefix
  # RDS
  vpc_id                      = module.vpc.vpc_id
  private_subnets             = module.vpc.private_subnets
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  rds_port                    = 5432
  rds_name                    = "mlflow"
  rds_engine                  = "mysql"
  rds_engine_version          = "8.0.33"
  rds_instance_class          = "db.t3.micro"
  rds_storage_type            = local.rds_storage_type
  rds_max_allocated_storage   = local.rds_max_allocated_storage

  # TODO: add data access common rule
  s3_data_bucket_user_name = "airflow-s3-data-bucket-user"

  depends_on = [
    module.eks
  ]
}


module "airflow" {
  count             = var.deploy_airflow ? 1 : 0
  source            = "./modules/airflow"
  name              = "airflow"
  namespace         = "airflow"
  name_prefix       = local.name_prefix
  cluster_name      = local.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  oidc_provider_arn = module.eks.oidc_provider_arn

  sagemaker_access_role_arn  = local.sagemaker_access_role_arn
  s3_data_bucket_secret_name = local.airflow_s3_data_bucket_credentials
  s3_data_bucket_name        = local.airflow_s3_data_bucket
  domain_name                = var.domain_name
  domain_suffix              = "airflow"
  fernet_key                 = var.airflow_fernet_key
  airflow_variable_list      = local.airflow_variable_list

  # RDS
  vpc_id                      = module.vpc.vpc_id
  private_subnets             = module.vpc.private_subnets
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  rds_port                    = 5000
  rds_name                    = "airflow"
  rds_engine                  = "postgres"
  rds_engine_version          = "13.11" # end of support may 2024
  rds_instance_class          = "db.t3.micro"
  rds_storage_type            = local.rds_storage_type
  rds_max_allocated_storage   = local.rds_max_allocated_storage
  # periodic updates
  # log airflow to s3

  # TODO: add data access common rule
  s3_data_bucket_user_name = "airflow-s3-data-bucket-user"
  # HELM
  helm_chart_repository = "https://airflow-helm.github.io/charts"
  helm_chart_name       = "airflow"
  helm_chart_version    = "8.7.1"

  git_username       = local.git_username
  git_token          = local.git_token
  git_repository_url = local.git_sync_repository_url
  git_branch         = local.git_sync_branch
  git_client_id      = var.airflow_git_client_id
  git_client_secret  = var.airflow_git_client_secret

  depends_on = [
    module.eks
  ]
}


module "jupyterhub" {
  count            = var.deploy_jupyterhub ? 1 : 0
  source           = "./modules/jupyterhub"
  name             = "jupyterhub"
  cluster_name     = local.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  domain_name      = var.domain_name
  domain_suffix    = "jupyterhub"

  git_repository_url = local.git_sync_repository_url
  git_client_id      = var.jupyterhub_git_client_id
  git_client_secret  = var.jupyterhub_git_client_secret
  proxy_secret_token = var.jupyterhub_proxy_secret_token

  # HELM
  helm_chart_repository = "https://jupyterhub.github.io/helm-chart/"
  helm_chart_name       = "jupyterhub"
  helm_chart_version    = "2.0.0"
  mlflow_tracking_uri   = "test" #var.deploy_mlflow ? module.mlflow.mlflow_tracking_uri : ""

  depends_on = [
    module.eks
  ]
}


module "monitoring" {
  count             = var.deploy_monitoring ? 1 : 0
  source            = "./modules/monitoring"
  name              = "monitoring"
  git_client_id     = var.grafana_git_client_id
  git_client_secret = var.grafana_git_client_secret
}


module "sagemaker" {
  count  = var.deploy_sagemaker ? 1 : 0
  source = "./modules/sagemaker"

  dockerhub_repository_name = "seblum/mlflow-sagemaker-deployment"
  repository_model_tag      = "v2.3.2"
}


module "dashboard" {
  count     = var.deploy_dashboard ? 1 : 0
  source    = "./modules/dashboard"
  name      = "dashboard"
  namespace = "dashboard"
}
