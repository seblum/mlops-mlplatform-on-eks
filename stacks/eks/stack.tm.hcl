stack {
  name        = "eks"
  description = "EKS cluster, managed node groups (t3.small/medium/large), cluster addons (CoreDNS, kube-proxy, EBS CSI, VPC CNI), EFS storage class."
  id          = "eks"
  tags        = ["infra", "kubernetes"]

  after = [
    "../vpc",
  ]
}
