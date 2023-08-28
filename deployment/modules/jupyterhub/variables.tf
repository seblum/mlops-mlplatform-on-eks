variable "cluster_endpoint" {
  description = "Endpoint of the EKS Cluster"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = ""
}

variable "create_namespace" {
  description = "Should the namespace be created if it does not exist?"
  type        = bool
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

variable "git_repository_url" {
  description = "Https URL to the Github repository to sync Airflow with"
  type        = string
  default     = ""
}

variable "helm_chart_name" {
  description = "Name of the helm chart"
  type        = string
  default     = ""
}

variable "helm_chart_repository" {
  description = "Repository URL or path to the location of the helm repo"
  type        = string
  default     = ""
}

variable "helm_chart_version" {
  description = "Version of the helm chart"
  type        = string
  default     = ""
}

variable "mlflow_tracking_uri" {
  description = "The internal address of MLflow, to make it easily accessible from Jupyter."
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

variable "proxy_secret_token" {
  description = "Secret token for proxy"
  type        = string
  default     = ""
}
