variable "create_namespace" {
  description = "Should the namespace be created if it does not exist?"
  type        = bool
  default     = true
}

variable "dockerhub_repository_name" {
  description = "Name of the DockerHub repository"
  type        = string
  default     = ""
}

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

variable "repository_model_tag" {
  description = "Tag for the repository model"
  type        = string
  default     = ""
}
