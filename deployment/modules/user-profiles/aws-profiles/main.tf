
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_user" "this" {
  name = var.profile.name
  path = "/"
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "random_string" "random_password" {
  length  = 8
  special = false
}

resource "aws_secretsmanager_secret" "this" {
  name                    = var.profile.name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(
    {
      "ACCESS_KEY_ID" : aws_iam_access_key.this.id,
      "SECRET_ACCESS_KEY" : aws_iam_access_key.this.secret
      "email" : var.profile.email
      "firstName" : split(".", var.profile.name)[0]
      "lastName" : split(".", var.profile.name)[1]
      "airflow-username" : var.profile.name
      "airflow-role" : var.profile.airflow_role
      "user-password" : random_string.random_password.result # password for airflow and jupyter
  })
}
