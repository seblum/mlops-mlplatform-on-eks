

variable "name" {}

variable "namespace" {}


variable "create_namespace" {
  type        = bool
  description = "Should the namespace be created, if it does not exists?"
  default     = true
}

