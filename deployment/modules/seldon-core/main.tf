
# resource "kubernetes_namespace" "seldon-system" {
#   metadata {

#     name = var.namespace
#   }
# }

# resource "kubernetes_secret" "seldon_secret_aws_bucket" {
#   metadata {
#     name      = s3-bucket
#     namespace = helm_release.airflow.namespace
#   }
#   stringData = {
   
#   }
# }


resource "helm_release" "seldon-core-operator" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = var.create_namespace

  repository = "https://storage.googleapis.com/seldon-charts"
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  values = [yamlencode({
    predictiveUnit = {
      defaultEnvSecretRefName = "s3-bucket"
    }
  })]
}



