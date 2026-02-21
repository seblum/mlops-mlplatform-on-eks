variable "profile" {
  description = "Profile configuration as object"
  type        = map(any)
  default = {
    "username"  = "max.mustermann"
    "email"     = "max.mustermann@example.com"
    "firstName" = "max"
    "lastName"  = "mustermann"
    "role"      = "Developer"
  }
}


variable "access_policy_developer" {

}

variable "access_policy_user" {

}
