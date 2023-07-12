

locals {
  cluster_name                       = "${local.deployment_name}-eks-cluster"
  vpc_name                           = "${local.deployment_name}-vpc"
  mlflow_s3_bucket_name              = "${local.name_prefix}-artifact-bucket"
  airflow_s3_data_bucket             = "data-storage"
  airflow_s3_data_bucket_credentials = "s3-data-bucket-access-credentials"
  port_airflow                       = 5000
  port_mlflow                        = 5432
  force_destroy_s3_bucket            = true
  storage_type                       = "gp2"
  max_allocated_storage              = var.max_allocated_storage
  airflow_github_ssh                 = var.airflow_github_ssh
  git_username                       = var.git_username
  git_token                          = var.git_token
  git_repository_url                 = var.git_repository_url
  git_branch                         = var.git_branch
  deployment_name                    = "airflow-platform"
  name_prefix                        = random_string.random_prefix.result

  # Profiles
  profiles_yaml = yamldecode(file("${path.module}/profiles/user-list.yaml"))["profiles"]

  profiles_config = {
    for profile in local.profiles_yaml : profile["user"] => {
      name         = profile["user"]
      email        = profile["email"]
      firstName    = split(".", profile["user"])[0]
      lastName     = split(".", profile["user"])[1]
      airflow_role = lookup(profile, "airflow_role", [])
    }
  }

  airflow_profiles = [
    for profile in local.profiles_yaml : {
      username  = profile["user"]
      password  = module.user-profiles.user_profile[profile["user"]]["user_password"]
      email     = profile["email"]
      role      = lookup(profile, "airflow_role", [])
      firstName = split(".", profile["user"])[0]
      lastName  = split(".", profile["user"])[1]
  }]

  jupyterhub_admin_user_list = flatten(compact([
    for profile in local.profiles_yaml : profile["jupyter_role"] == "Admin" ? profile["user"] : ""
  ]))

  jupyterhub_allowed_user_list = flatten(compact([
    for profile in local.profiles_yaml : profile["jupyter_role"] == "User" ? profile["user"] : ""
  ]))


}