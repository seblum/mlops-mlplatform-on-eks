locals {
  k8s_airflow_db_secret_name   = "${var.name}-db-auth"
  git_airflow_repo_secret_name = "${var.name}-https-git-secret"
}

resource "aws_s3_bucket" "airflow" {
  bucket = "airflow-bucket-logs"
  # tags          = var.tags
  force_destroy = var.s3_force_destroy
}

resource "kubernetes_secret" "airflow_db_credentials" {
  metadata {
    name      = local.k8s_airflow_db_secret_name
    namespace = helm_release.airflow.namespace
  }
  data = {
    "postgresql-password" = module.rds-airflow.rds_password
  }
}


resource "kubernetes_secret" "airflow_tasks_aws_access_credentials" {
  metadata {
    name      = "airflow-tasks-aws-access-credentials"
    namespace = helm_release.airflow.namespace
  }
  data = {
    "AWS_REGION" = "eu-central-1"
    "AWS_BUCKET"="airflowdatabucket"
    "AWS_ACCESS_KEY_ID"="AKIA4OKBSADPRSFYYETY"
    "AWS_SECRET_ACCESS_KEY"="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"
    "AWS_ROLE_NAME"="airflow-test-role"
  }
}


# resource "kubernetes_secret" "airflow_aws_s3_log_secret" {
#   metadata {
#     name      = "airflow-aws-s3-log-secret"
#     namespace = helm_release.airflow.namespace
#   }
#   data = {
#     "AWS_REGION" = "eu-central-1"
#     "AWS_ACCESS_KEY_ID"="AKIA4OKBSADPRSFYYETY"
#     "AWS_SECRET_ACCESS_KEY"="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"
#   }
# }


resource "kubernetes_secret" "airflow_https_git_secret" {
  metadata {
    name      = local.git_airflow_repo_secret_name
    namespace = helm_release.airflow.namespace
  }
  data = {
    "username" = var.git_username
    "password" = var.git_token
  }
}

resource "random_password" "rds_password" {
  length  = 16
  special = false
}


# create rds for airflow
module "rds-airflow" {
  source                      = "../../infrastructure/rds"
  vpc_id                      = var.vpc_id
  private_subnets             = var.private_subnets
  private_subnets_cidr_blocks = var.private_subnets_cidr_blocks
  rds_port                    = var.rds_port
  rds_name                    = var.rds_name
  rds_password                = coalesce(var.rds_password, random_password.rds_password.result)
  rds_engine                  = var.rds_engine
  rds_engine_version          = var.rds_engine_version
  rds_instance_class          = var.rds_instance_class
  storage_type                = var.storage_type
  max_allocated_storage       = var.max_allocated_storage
}



resource "helm_release" "airflow" {
  name             = var.name
  namespace        = var.name
  create_namespace = var.create_namespace

  repository = "https://airflow-helm.github.io/charts" #var.helm_chart_repository
  chart      = var.helm_chart_name
  version    = var.helm_chart_version
  wait       = false # deactivate post install hooks otherwise will fail

  values = [
    "${file("${path.module}/helm/values.yaml")}"
  ]

  # set {
  #   name = "externalDatabase.database"
  #   value = "airflow_db"
  # }
  set {
    name  = "externalDatabase.port"
    value = var.rds_port
  }
  set {
    name  = "externalDatabase.host"
    value = module.rds-airflow.rds_host
  }
  set {
    name  = "externalDatabase.passwordSecret"
    value = local.k8s_airflow_db_secret_name
  }
  set {
    name  = "dags.gitSync.repo"
    value = var.git_repository_url
  }
  set {
    name  = "dags.gitSync.branch"
    value = var.git_branch
  }
  set {
    name  = "dags.gitSync.httpSecret"
    value = local.git_airflow_repo_secret_name
  }
  # set {
  #   name = "env[0].name"
  #   value = "MLFLOW_TRACKING_URI"
  # }
  # set {
  #   name = "env[0].value"
  #   value = var.mlflow_tracking_uri
  # }

}
