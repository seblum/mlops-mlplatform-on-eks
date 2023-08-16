variable "name_prefix" {

}

variable "name" {}

variable "namespace" {}


variable "create_namespace" {
  type        = bool
  description = "Should the namespace be created, if it does not exists?"
  default     = true
}

variable "oidc_provider_arn" {
  type        = string
  description = "arn of the OIDC provider"
}

