locals {
  seldon_aws_s3_credentials_secret_name = "aws-s3-credentials"
}
# resource "kubernetes_namespace" "seldon-system" {
#   metadata {

#     name = var.namespace
#   }
# }

resource "kubernetes_secret" "seldon_aws_s3_credentials" {
  metadata {
    name      = local.seldon_aws_s3_credentials_secret_name
    namespace = helm_release.seldon-core-operator.namespace
  }
  data = {
    "RCLONE_CONFIG_S3_TYPE"              = "s3"
    "RCLONE_CONFIG_S3_PROVIDER"          = "AWS"
    "RCLONE_CONFIG_S3_ENV_AUTH"          = "false"
    "RCLONE_CONFIG_S3_ACCESS_KEY_ID"     = ""
    "RCLONE_CONFIG_S3_SECRET_ACCESS_KEY" = ""
  }
}

resource "helm_release" "seldon-core-operator" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = var.create_namespace

  repository = "https://storage.googleapis.com/seldon-charts"
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  values = [yamlencode({
    predictiveUnit = {
      defaultEnvSecretRefName = local.seldon_aws_s3_credentials_secret_name
    }
  })]
}



