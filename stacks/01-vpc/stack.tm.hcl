stack {
  name        = "01-vpc"
  description = "VPC: subnets, NAT gateway, security groups. Outputs consumed by eks and rds stacks."
  id          = "vpc"
  tags        = ["infra"]

  after = ["../00-bootstrap"]
}
