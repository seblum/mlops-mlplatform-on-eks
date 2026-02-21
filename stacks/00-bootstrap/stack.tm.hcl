stack {
  name        = "00-bootstrap"
  description = "Creates the S3 state bucket and DynamoDB lock table. Apply once manually before all other stacks."
  id          = "bootstrap"
  tags        = ["infra"]
}
