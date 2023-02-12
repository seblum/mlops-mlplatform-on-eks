locals {
  k8s_secret_name = "rds-password-secret"
}

resource "kubernetes_namespace" "namespace_coder" {
  metadata {
    name = var.tag_name
  }
}

resource "random_password" "rds_password" {
  length  = 16
  special = false
}


# create rds for airflow
module "rds-coder" {
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


resource "helm_release" "coder" {
  name      = var.tag_name
  namespace = var.tag_name

  repository = "https://helm.coder.com" #var.helm_chart_repository
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  #values = ["eks_terraform/applications/airflow/values.yaml"]
  #   values     = [file("${path.root}/helm/airflow.yml")]
  values = ["${file("/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/eks_terraform/applications/coder/values.yaml")}"]

  set {
    name  = "postgres.host"
    value = module.rds-coder.rds_host
  }
  set {
    name  = "postgres.port"
    value = var.rds_port
  }
  set {
    name  = "postgres.user"
    value = module.rds-coder.rds_username
  }
  set {
    name  = "postgres.database"
    value = module.rds-coder.rds_dbname
  }
  set {
    name  = "postgres.passwordSecret"
    value = local.k8s_secret_name
  }
}

resource "kubernetes_secret" "coder-secret" {
  metadata {
    name      = local.k8s_secret_name
    namespace = var.tag_name
  }
  data = {
    password = module.rds-coder.rds_password
  }

  type = "kubernetes.io/basic-auth"
}
