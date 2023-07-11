output "machine_user_profile" {
  value = {
    profile_name = var.profile.name
    #role_arn     = aws_iam_role.profile.arn
    user_name     = aws_iam_user.this.name
    user_arn      = aws_iam_user.this.arn
    profile       = var.profile
    user_password = random_string.random_password.result
    #aws_iam_access_key.this.id
  }
}

# users     = lookup(profile, "users", [])