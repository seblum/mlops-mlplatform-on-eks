stack {
  name        = "vpc"
  description = "AWS VPC: subnets, NAT gateway, security groups."
  id          = "vpc"
  tags        = ["infra", "networking"]

  after = [
    "../bootstrap",
  ]
}
