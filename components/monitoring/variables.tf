variable "create_namespace" {
  type        = bool
  description = "Should the namespace be created if it does not exist?"
  default     = true
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = ""
}

variable "domain_suffix" {
  description = "Domain suffix"
  type        = string
  default     = ""
}

variable "git_client_id" {
  description = "Client ID for Git integration"
  type        = string
  default     = ""
}

variable "git_client_secret" {
  description = "Client secret for Git integration"
  type        = string
  default     = ""
}

variable "name" {
  description = "Name"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "Namespace to launch Prometheus & Grafana"
  type        = string
  default     = "monitoring"
}
