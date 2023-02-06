
resource "kubernetes_namespace" "namespace-mlflow" {
  metadata {
    name = "mlflow"
  }
}


# create s3 bucket for artifacts
# create rds for s3
