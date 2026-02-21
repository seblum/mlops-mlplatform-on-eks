stack {
  name        = "03-networking"
  description = "AWS Load Balancer Controller and External-DNS Helm releases with IRSA."
  id          = "networking"
  tags        = ["infra", "app"]

  after = ["../02-eks"]
}
