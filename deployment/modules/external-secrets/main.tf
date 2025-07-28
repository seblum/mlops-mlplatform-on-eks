terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }
  }
}

locals {
  labels = merge({
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/name"       = "external-secrets"
  }, var.labels)
}

resource "helm_release" "external_secrets" {
  name       = var.release_name
  repository = var.chart_repository
  chart      = var.chart_name
  version    = var.chart_version
  namespace  = var.namespace

  create_namespace = true

  values = [
    yamlencode({
      serviceAccount = {
        create = var.create_service_account
        name   = var.service_account_name
        annotations = {
          "eks.amazonaws.com/role-arn" = var.irsa_role_arn
        }
      }
    })
  ]

  lint          = true
  dependency_update = true
}
