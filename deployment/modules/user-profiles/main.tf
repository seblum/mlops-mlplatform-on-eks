
module "aws-profiles" {
  for_each = var.profiles
  source   = "./aws-profiles"

  profile = each.value

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
