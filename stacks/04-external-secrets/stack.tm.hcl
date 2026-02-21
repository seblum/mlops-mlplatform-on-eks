stack {
  name        = "04-external-secrets"
  description = "External Secrets Operator Helm release and ClusterSecretStore backed by AWS Secrets Manager."
  id          = "external-secrets"
  tags        = ["infra", "app"]

  after = ["../02-eks"]
}
