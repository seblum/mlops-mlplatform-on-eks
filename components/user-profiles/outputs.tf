output "user_profile" {
  description = "User profiles for the machine"
  value       = local.machine_user_profiles
}

output "aws_user_access_profile" {
  description = "User profiles for the machine"
  value       = local.aws_user_access_profiles
}
