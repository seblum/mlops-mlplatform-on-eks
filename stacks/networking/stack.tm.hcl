stack {
  name        = "networking"
  description = "AWS Load Balancer Controller and External-DNS (Helm releases with IRSA)."
  id          = "networking"
  tags        = ["infra", "networking"]

  after = [
    "../eks-addons",
  ]
}
