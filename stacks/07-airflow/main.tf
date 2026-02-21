data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "mlplatform-terraform-state"
    key    = "stacks/vpc/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "mlplatform-terraform-state"
    key    = "stacks/eks/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "mlflow" {
  backend = "s3"
  config = {
    bucket = "mlplatform-terraform-state"
    key    = "stacks/mlflow/terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "random_string" "name_prefix" {
  length  = 12
  upper   = false
  special = false
}

variable "domain_name" {
  type    = string
  default = ""
}

variable "airflow_fernet_key" {
  type      = string
  sensitive = true
  default   = ""
}

variable "git_sync_repository_url" {
  type    = string
  default = ""
}

variable "git_sync_branch" {
  type    = string
  default = "main"
}

variable "git_username" {
  type    = string
  default = ""
}

variable "git_token" {
  type      = string
  sensitive = true
  default   = ""
}

variable "airflow_git_client_id" {
  type    = string
  default = ""
}

variable "airflow_git_client_secret" {
  type      = string
  sensitive = true
  default   = ""
}

# Optional: sagemaker info for Airflow variables (defaults if sagemaker not deployed)
variable "sagemaker_access_role_name" {
  type    = string
  default = "not-deployed"
}

variable "ecr_repository_name" {
  type    = string
  default = "not-deployed"
}

variable "ecr_sagemaker_image_tag" {
  type    = string
  default = "not-deployed"
}

locals {
  name_prefix = random_string.name_prefix.result

  airflow_variable_list = [
    { key = "MLFLOW_TRACKING_URI", value = data.terraform_remote_state.mlflow.outputs.mlflow_tracking_uri },
    { key = "ECR_REPOSITORY_NAME", value = var.ecr_repository_name },
    { key = "ECR_SAGEMAKER_IMAGE_TAG", value = var.ecr_sagemaker_image_tag },
    { key = "s3_access_name", value = "airflow-${var.airflow_git_client_id != "" ? local.name_prefix : "default"}-s3-data-bucket-access-credentials" },
  ]
}

module "airflow" {
  source            = "../../components/airflow"
  name              = "airflow"
  namespace         = "airflow"
  name_prefix       = local.name_prefix
  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_name
  cluster_endpoint  = data.terraform_remote_state.eks.outputs.cluster_endpoint
  oidc_provider_arn = data.terraform_remote_state.eks.outputs.oidc_provider_arn

  sagemaker_access_role_name  = var.sagemaker_access_role_name
  s3_mlflow_bucket_policy_arn = data.terraform_remote_state.mlflow.outputs.mlflow_s3_policy_arn
  s3_data_bucket_secret_name  = "s3-data-bucket-access-credentials"
  s3_data_bucket_name         = "data-storage"
  domain_name                 = var.domain_name
  domain_suffix               = "airflow"
  fernet_key                  = var.airflow_fernet_key
  airflow_variable_list       = local.airflow_variable_list

  vpc_id                      = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnets             = data.terraform_remote_state.vpc.outputs.private_subnets
  private_subnets_cidr_blocks = data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks

  rds_port                  = 5432
  rds_name                  = "airflow"
  rds_engine                = "postgres"
  rds_engine_version        = "16.4"
  rds_instance_class        = "db.t3.micro"
  rds_storage_type          = "gp2"
  rds_max_allocated_storage = 500

  helm_chart_repository = "https://airflow-helm.github.io/charts"
  helm_chart_name       = "airflow"
  helm_chart_version    = "8.9.0"

  git_username       = var.git_username
  git_token          = var.git_token
  git_repository_url = var.git_sync_repository_url
  git_branch         = var.git_sync_branch
  git_client_id      = var.airflow_git_client_id
  git_client_secret  = var.airflow_git_client_secret
}
