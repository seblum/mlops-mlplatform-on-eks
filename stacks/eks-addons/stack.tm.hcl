stack {
  name        = "eks-addons"
  description = "Cluster Autoscaler (Helm), EFS CSI driver (Helm), cluster-level IAM policies."
  id          = "eks-addons"
  tags        = ["infra", "kubernetes"]

  after = [
    "../eks",
  ]
}
