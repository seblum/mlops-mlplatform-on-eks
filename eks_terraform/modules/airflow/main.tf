resource "kubernetes_namespace" "ns-airflow" {
  metadata {
    name = var.tag_name
  }
}

resource "kubernetes_secret" "airflow_db_credentials" {
  metadata {
    name      = "${var.tag_name}-db-auth"
    namespace = kubernetes_namespace.ns-airflow.metadata[0].name
  }
  data = {
    "postgresql-password" = module.rds-airflow.rds_password
  }
}

resource "kubernetes_secret" "airflow_git_ssh_secret" {
  metadata {
    name      = "${var.tag_name}-git-ssh-secret"
    namespace = kubernetes_namespace.ns-airflow.metadata[0].name
  }
  data = {
    "gitSshKey" = var.github_ssh
  }
}

# create rds for airflow
module "rds-airflow" {
  source                      = "../../infrastructure/rds"
  vpc_private_subnets         = var.private_subnets
  private_subnets_cidr_blocks = var.private_subnets_cidr_blocks
  vpc_id                      = var.vpc_id
  rds_port                    = var.rds_port
  rds_name                    = var.rds_name
  rds_engine                  = var.rds_engine
  rds_engine_version          = var.rds_engine_version
  storage_type                = var.storage_type
  max_allocated_storage       = var.max_allocated_storage
}



resource "helm_release" "airflow" {
  name      = var.tag_name
  namespace = var.tag_name

  repository = var.helm_chart_repository
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  values = ["${file("/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/eks_terraform/applications/airflow/values.yaml")}"]
}
