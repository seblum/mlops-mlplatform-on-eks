data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "mlplatform-terraform-state"
    key    = "stacks/eks/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "aws_caller_identity" "current" {}

# IRSA role granting ESO service account access to AWS Secrets Manager
resource "aws_iam_role" "eso" {
  name = "external-secrets-operator-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRoleWithWebIdentity"
      Effect    = "Allow"
      Principal = { Federated = data.terraform_remote_state.eks.outputs.oidc_provider_arn }
      Condition = {
        StringEquals = {
          "${replace(data.terraform_remote_state.eks.outputs.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:external-secrets:external-secrets-sa"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eso_secrets_manager" {
  role       = aws_iam_role.eso.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

module "external_secrets" {
  source       = "../../components/external-secrets"
  irsa_role_arn = aws_iam_role.eso.arn
}
