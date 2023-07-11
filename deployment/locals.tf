# Profiles

locals {

  profiles_yaml = yamldecode(file("${path.module}/profiles/user-list.yaml"))["profiles"]

  profiles_config = {
    for profile in local.profiles_yaml : profile["user"] => {
      name      = profile["user"]
      email     = profile["email"]
      firstName = split(".", profile["user"])[0]
      lastName  = split(".", profile["user"])[1]
      #airflow_username = profile["user"]
      airflow_role = lookup(profile, "airflow_role", [])
    }
  }

  airflow_profiles = [
    for profile in local.profiles_yaml : {
      username  = profile["user"]
      password  = module.user-profiles.user_profile[profile["user"]]["user_password"]
      email     = profile["email"]
      role      = lookup(profile, "airflow_role", [])
      firstName = split(".", profile["user"])[0]
      lastName  = split(".", profile["user"])[1]
  }]


}