locals {
  cluster_name                       = "${local.deployment_name}-eks-cluster"
  vpc_name                           = "${local.deployment_name}-vpc"
  mlflow_s3_bucket_name              = "artifact-bucket"
  airflow_s3_data_bucket             = "data-storage"
  airflow_s3_data_bucket_credentials = "s3-data-bucket-access-credentials"
  force_destroy_s3_bucket            = true
  rds_storage_type                   = "gp2"
  rds_max_allocated_storage          = 500 # "The upper limit of scalable storage (GB)"
  airflow_github_ssh                 = var.airflow_github_ssh
  git_username                       = var.git_username
  git_token                          = var.git_token
  git_sync_repository_url            = var.git_sync_repository_url
  git_sync_branch                    = var.git_sync_branch
  deployment_name                    = "mlplatform"
  name_prefix                        = random_string.random_prefix.result

  # Profiles
  profiles_yaml = yamldecode(file("${path.module}/profiles/user-list.yaml"))["profiles"]

  profiles_config = {
    for profile in local.profiles_yaml : profile["username"] => {
      username  = profile["username"]
      email     = profile["email"]
      firstName = split(".", profile["username"])[0]
      lastName  = split(".", profile["username"])[1]
      role      = profile["role"]
    }
  }

  developers_user_access_auth_list = [
    for role_arn in module.user-profiles.aws_user_access_profile["Developer"] : {
      userarn  = role_arn["user_arn"]
      username = role_arn["username"]
      groups   = ["system:masters"]
    }
  ]

  # "http://mlflow-service.mlflow.svc.cluster.local"
  mlflow_tracking_uri       = var.deploy_mlflow ? module.mlflow[0].mlflow_tracking_uri : "not-deployed"
  sagemaker_access_role_arn = var.deploy_sagemaker ? module.sagemaker[0].sagemaker_access_role_arn : "not-deployed"
  ecr_repository_name       = var.deploy_sagemaker ? module.sagemaker[0].ecr_repository_name : "not-deployed"
  ecr_sagemaker_image_tag   = var.deploy_sagemaker ? module.sagemaker[0].repository_model_tag : "not-deployed"

  airflow_variable_list = [
    {
      "key"   = "MLFLOW_TRACKING_URI"
      "value" = local.mlflow_tracking_uri
    },
    {
      "key"   = "ECR_REPOSITORY_NAME"
      "value" = local.ecr_repository_name
    },
    {
      "key"   = "ECR_SAGEMAKER_IMAGE_TAG"
      "value" = local.ecr_sagemaker_image_tag
    },
  ]

}

resource "random_string" "random_prefix" {
  length  = 12
  upper   = false
  special = false
}