stack {
  name        = "bootstrap"
  description = "Bootstraps the Terraform S3 state backend and DynamoDB lock table. Must be applied once before all other stacks."
  id          = "bootstrap"
  tags        = ["infra", "bootstrap"]
}
