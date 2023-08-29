locals {
  firstName = split(".", var.profile.username)[0]
  lastName  = split(".", var.profile.username)[1]
  role      = var.profile.role
  username  = "${local.firstName}-${local.lastName}"
}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_user" "this" {
  name = local.username
  path = "/"
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_iam_role" "user_access_role" {
  name                 = "mlplatform-access-${local.firstName}-${local.lastName}"
  max_session_duration = 28800

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${aws_iam_user.this.name}"
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
              "Service": "s3.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  }
  EOF
  #   # tags = {
  #   #   tag-key = "tag-value"
  #   # }
}

resource "aws_iam_role_policy_attachment" "role_attachement_policy_developer" {
  count      = local.role == "Developer" ? 1 : 0
  role       = aws_iam_role.user_access_role.name
  policy_arn = var.access_policy_developer
}

resource "aws_iam_role_policy_attachment" "role_attachement_policy_user" {
  count      = local.role == "User" ? 1 : 0
  role       = aws_iam_role.user_access_role.name
  policy_arn = var.access_policy_user
}

resource "aws_secretsmanager_secret" "this" {
  name                    = var.profile.username
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(
    {
      "ACCESS_KEY_ID" : aws_iam_access_key.this.id,
      "SECRET_ACCESS_KEY" : aws_iam_access_key.this.secret
      "username" : var.profile.username
      "email" : var.profile.email
      "role" : local.role
      "firstName" : local.firstName
      "lastName" : local.lastName
      "AWS_role" : aws_iam_role.user_access_role.arn
  })
}
