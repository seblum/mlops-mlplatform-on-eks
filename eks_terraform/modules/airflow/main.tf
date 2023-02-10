resource "kubernetes_namespace" "namespace_airflow" {
  metadata {
    name = var.tag_name
  }
}

resource "kubernetes_secret" "airflow_db_credentials" {
  metadata {
    name      = "${var.tag_name}-db-auth"
    namespace = kubernetes_namespace.namespace_airflow.metadata[0].name
  }
  data = {
    "postgresql-password" = module.rds-airflow.rds_password
  }
}


resource "kubernetes_secret" "airflow_https_git_secret" {
  metadata {
    name      = "${var.tag_name}-https-git-secret"
    namespace = kubernetes_namespace.namespace_airflow.metadata[0].name
  }
  data = {
    "username" = var.git_username
    "password" = var.git_token
  }
}

resource "random_password" "rds_password" {
  length  = 16
  special = true
}


# create rds for airflow
module "rds-airflow" {
  source                      = "../../infrastructure/rds"
  vpc_id                      = var.vpc_id
  vpc_private_subnets         = var.private_subnets
  private_subnets_cidr_blocks = var.private_subnets_cidr_blocks
  rds_port                    = var.rds_port
  rds_name                    = var.rds_name
  rds_password                = coalesce(var.rds_password, random_password.rds_password.result)
  rds_engine                  = var.rds_engine
  rds_engine_version          = var.rds_engine_version
  #parameter_group_name        = var.parameter_group_name
  rds_instance_class    = var.rds_instance_class
  storage_type          = var.storage_type
  max_allocated_storage = var.max_allocated_storage
}



resource "helm_release" "airflow" {
  name      = var.tag_name
  namespace = var.tag_name

  repository = "https://airflow-helm.github.io/charts" #var.helm_chart_repository
  chart      = var.helm_chart_name
  version    = var.helm_chart_version
  wait       = false # deactivate post install hooks otherwise will fail

  #values = ["eks_terraform/applications/airflow/values.yaml"]
  #   values     = [file("${path.root}/helm/airflow.yml")]
  values = ["${file("/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/eks_terraform/applications/airflow/values.yaml")}"]

  set {
    name  = "externalDatabase.port"
    value = var.rds_port
  }
}
