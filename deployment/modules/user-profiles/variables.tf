variable "profiles" {
  type = map(any)
}

variable "eks_oidc_provider" {
  description = "OIDC provider for EKS cluster, e.g. oidc.eks.eu-central-1.amazonaws.com/id/<unique id>"
  type        = string
  default     = ""
}
