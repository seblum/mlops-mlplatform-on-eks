
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy" "AmazonSageMakerFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}


module "aws-profiles" {
  for_each = var.profiles
  source   = "./aws-profiles"
  profile  = each.value

  access_policy_developer = aws_iam_policy.mlplatform_developer_access_policy.arn
  access_policy_user      = aws_iam_policy.mlplatform_user_access_policy.arn
}


resource "aws_iam_policy" "mlplatform_developer_access_policy" {
  name        = "mlplatform-developer-access-policy"
  description = "Access for platform developers granting them full EKS, EC2, S3, RDS, VPC access"

  policy = file("${path.module}/access_policies/AccessPolicyDeveloper.json")
}

resource "aws_iam_policy" "mlplatform_user_access_policy" {
  name        = "mlplatform-user-access-policy"
  description = "Access for platform users granting them access to Sagemaker"

  policy = file("${path.module}/access_policies/AccessPolicyUser.json")
}

resource "aws_iam_role_policy_attachment" "sagemaker_access_user_role_policy" {
  for_each = toset(local.user_user_access_auth_list)

  role       = each.value
  policy_arn = data.aws_iam_policy.AmazonSageMakerFullAccess.arn
}
