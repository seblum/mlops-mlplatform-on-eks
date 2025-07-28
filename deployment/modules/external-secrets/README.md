# external-secrets Terraform Module

Deploys the External Secrets Operator on an EKS cluster using the Helm provider.

## Resources

* Helm release of `external-secrets/external-secrets` chart.
* Optional service account annotated for IRSA.

## Usage

```hcl
module "external_secrets" {
  source = "./deployment/modules/external-secrets"

  irsa_role_arn = aws_iam_role.external_secrets.arn
  chart_version = "0.9.11"
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `release_name` | Helm release name | `string` | `external-secrets` |
| `namespace` | K8s namespace | `string` | `external-secrets` |
| `chart_repository` | Helm repo URL | `string` | `https://charts.external-secrets.io` |
| `chart_name` | Chart name | `string` | `external-secrets` |
| `chart_version` | Chart version | `string` | `0.9.11` |
| `create_service_account` | Whether to create SA | `bool` | `true` |
| `service_account_name` | Service account name | `string` | `external-secrets-sa` |
| `irsa_role_arn` | IAM role ARN for SA | `string` | `""` |
| `labels` | Extra labels | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| `release_name` | Helm release name |
| `namespace` | Namespace deployed |

## IRSA IAM Policy Example

```hcl
resource "aws_iam_role" "external_secrets" {
  name               = "external-secrets-role"
  assume_role_policy = data.aws_iam_policy_document.irsa.json
}

resource "aws_iam_role_policy" "sm_access" {
  name   = "secretsmanager-access"
  role   = aws_iam_role.external_secrets.id
  policy = data.aws_iam_policy_document.sm_access.json
}
```

Refer to the AWS Secrets Manager docs for least-privilege policy examples.
