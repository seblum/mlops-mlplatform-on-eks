locals {
  mlflow_s3_bucket_name = "${var.name_prefix}-${var.namespace}-${var.mlflow_s3_bucket_name}"
}

data "aws_caller_identity" "current" {}
# TODO: set namespace before ressourcs right

resource "helm_release" "dashboard" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = var.create_namespace

  chart = "${path.module}/helm/"
  values = [
    "${file("${path.module}/helm/values.yaml")}"
  ]
}



