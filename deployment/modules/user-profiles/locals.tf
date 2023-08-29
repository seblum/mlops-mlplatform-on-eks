locals {

  machine_user_profiles = {
    for m in module.aws-profiles : m.machine_user_profile.profile_name => m.machine_user_profile
  }

  aws_user_access_profiles = {
    for m in module.aws-profiles : m.user_access_role.role => m.aws_user_access_profile...
  }
}