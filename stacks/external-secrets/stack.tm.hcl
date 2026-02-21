stack {
  name        = "external-secrets"
  description = "External Secrets Operator (ESO) and ClusterSecretStore pointed at AWS Secrets Manager. All other app stacks that need secrets depend on this."
  id          = "external-secrets"
  tags        = ["infra", "security"]

  after = [
    "../eks-addons",
  ]
}
