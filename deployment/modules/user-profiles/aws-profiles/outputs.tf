output "machine_user_profile" {
  value = {
    profile_name  = var.profile.name
    user_name     = aws_iam_user.this.name
    user_arn      = aws_iam_user.this.arn
    profile       = var.profile
    user_password = random_string.random_password.result
  }
}
