# locals {
#   k8s_rds_secret_name = "rds-password-secret"
#   k8s_coder_secret_name = "coder-admin-secret"
# }

resource "kubernetes_namespace" "namespace_coder" {
  metadata {
    name = var.tag_name
  }
}

# resource "kubernetes_secret" "coder-admin-secret" {
#   metadata {
#     name      = local.k8s_coder_secret_name
#     namespace = var.tag_name
#   }
#   data = {
#     password = var.coder_admin_secret
#   }
# }

# resource "kubernetes_secret" "coder-rds-secret" {
#   metadata {
#     name      = local.k8s_rds_secret_name
#     namespace = var.tag_name
#   }
#   data = {
#     password = module.rds-coder.rds_password
#   }

#   type = "kubernetes.io/basic-auth"
# }

# resource "random_password" "rds_password" {
#   length  = 16
#   special = false # TODO set to true
# }


# # create rds for airflow
# module "rds-coder" {
#   source                      = "../../infrastructure/rds"
#   vpc_id                      = var.vpc_id
#   private_subnets             = var.private_subnets
#   private_subnets_cidr_blocks = var.private_subnets_cidr_blocks
#   rds_port                    = var.rds_port
#   rds_name                    = var.rds_name
#   rds_password                = coalesce(var.rds_password, random_password.rds_password.result)
#   rds_engine                  = var.rds_engine
#   rds_engine_version          = var.rds_engine_version
#   rds_instance_class          = var.rds_instance_class
#   storage_type                = var.storage_type
#   max_allocated_storage       = var.max_allocated_storage
# }


resource "helm_release" "coder" {
  name      = var.tag_name
  chart     = "/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/eks_terraform/applications/code-server/"
  namespace = var.tag_name

  #values = ["eks_terraform/applications/airflow/values.yaml"]
  #   values     = [file("${path.root}/helm/airflow.yml")]
  values = ["${file("/Users/sebastian.blum/Documents/Personal/Airflow_on_EKS/eks_terraform/applications/code-server/values.yaml")}"]

  # set {
  #   name = "coderd.superAdmin.passwordSecret"
  #   value = local.k8s_coder_secret_name
  # }
}
