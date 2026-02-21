stack {
  name        = "02-eks"
  description = "EKS cluster (v1.32), managed node groups, cluster addons (CoreDNS, kube-proxy, EBS/VPC CNI), Cluster Autoscaler, EFS CSI driver and storage class."
  id          = "eks"
  tags        = ["infra"]

  after = ["../01-vpc"]
}
