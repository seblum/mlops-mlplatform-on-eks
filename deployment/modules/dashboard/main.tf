
resource "helm_release" "dashboard" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = var.create_namespace

  chart = "${path.module}/helm/"
  values = [
    "${file("${path.module}/helm/values.yaml")}"
  ]
}



