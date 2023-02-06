
resource "kubernetes_namespace" "namespace-monitoring" {
  metadata {
    name = "monitoring"
  }
}
