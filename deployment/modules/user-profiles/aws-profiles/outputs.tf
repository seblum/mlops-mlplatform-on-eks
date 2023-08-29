output "machine_user_profile" {
  description = "Machine user profile information"
  value = {
    profile_name = var.profile.username
    user_name    = aws_iam_user.this.name
    user_arn     = aws_iam_user.this.arn
    profile      = var.profile
  }
}

output "aws_user_access_profile" {
  value = {
    user_arn = aws_iam_user.this.arn
    username = local.username
  }
}

output "user_access_role" {
  value = {
    role = local.role
  }
}