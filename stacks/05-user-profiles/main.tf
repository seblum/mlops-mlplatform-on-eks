data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "mlplatform-terraform-state"
    key    = "stacks/eks/terraform.tfstate"
    region = "eu-central-1"
  }
}

locals {
  profiles_yaml = yamldecode(file("${path.module}/../../profiles/user-list.yaml"))["profiles"]

  profiles_config = {
    for p in local.profiles_yaml : p["username"] => {
      username  = p["username"]
      email     = p["email"]
      firstName = split(".", p["username"])[0]
      lastName  = split(".", p["username"])[1]
      role      = p["role"]
    }
  }
}

module "user_profiles" {
  source            = "../../components/user-profiles"
  profiles          = local.profiles_config
  eks_oidc_provider = data.terraform_remote_state.eks.outputs.oidc_provider_arn
}
