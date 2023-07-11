locals {

  machine_user_profiles = {
    for m in module.aws-profiles : m.machine_user_profile.profile_name => m.machine_user_profile
  }
}