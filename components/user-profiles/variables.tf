variable "eks_oidc_provider" {
  description = "OIDC provider for EKS cluster, e.g. oidc.eks.<REGION-NAME>.amazonaws.com/id/<UNIQUE-ID>"
  type        = string
  default     = ""
}

variable "profiles" {
  description = "user profiles with relevant information to create AWS users from profiles_config"
  type        = map(any)
  default = {
    "username"  = "max.mustermann"
    "email"     = "max.mustermann@example.com"
    "firstName" = "max"
    "lastName"  = "mustermann"
    "role"      = "Developer"
  }
}
