variable "name" {
  description = "Name"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "Namespace"
  type        = string
  default     = ""
}

variable "create_namespace" {
  description = "Should the namespace be created if it does not exist?"
  type        = bool
  default     = true
}
