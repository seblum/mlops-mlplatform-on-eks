
module "aws-profiles" {
  for_each = var.profiles
  source   = "./aws-profiles"

  profile = each.value

}