variable "AWS_ACCESS_KEY" {
  description = "AWS access key id"
  type        = string
  default     = ""
}

variable "AWS_SECRET_KEY" {
  description = "AWS secret access key"
  type        = string
  default     = ""
}

variable "AWS_REGION" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "airflow_fernet_key" {
  description = "Fernet key for Airflow encryption"
  type        = string
  default     = ""
}

variable "airflow_github_ssh" {
  description = "SSH key for Airflow GitHub repository"
  type        = string
  default     = ""
}

variable "airflow_git_client_id" {
  description = "Client ID for Airflow Git integration"
  type        = string
  default     = ""
}

variable "airflow_git_client_secret" {
  description = "Client secret for Airflow Git integration"
  type        = string
  default     = ""
}

variable "deploy_airflow" {
  description = "Should Airflow be deployed?"
  type        = bool
  default     = false
}

variable "deploy_dashboard" {
  description = "Should the dashboard be deployed?"
  type        = bool
  default     = false
}

variable "deploy_jupyterhub" {
  description = "Should JupyterHub be deployed?"
  type        = bool
  default     = false
}

variable "deploy_mlflow" {
  description = "Should MLflow be deployed?"
  type        = bool
  default     = false
}

variable "deploy_monitoring" {
  description = "Should monitoring be deployed?"
  type        = bool
  default     = false
}

variable "deploy_sagemaker" {
  description = "Should Seldon Core be deployed?"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Domain name for deployment"
  type        = string
  default     = ""
}

variable "git_sync_branch" {
  description = "Name of the git branch of the Airflow DAG repository"
  type        = string
  default     = ""
}

variable "git_sync_repository_url" {
  description = "Https git url to the Airflow DAG repository"
  type        = string
  default     = ""
}

variable "git_token" {
  description = "Token for Git authentication"
  type        = string
  default     = ""
}

variable "git_username" {
  description = "Username for Git authentication"
  type        = string
  default     = ""
}

variable "grafana_git_client_id" {
  description = "Client ID for Grafana Git integration"
  type        = string
  default     = ""
}

variable "grafana_git_client_secret" {
  description = "Client secret for Grafana Git integration"
  type        = string
  default     = ""
}

variable "jupyterhub_git_client_id" {
  description = "Client ID for JupyterHub Git integration"
  type        = string
  default     = ""
}

variable "jupyterhub_git_client_secret" {
  description = "Client secret for JupyterHub Git integration"
  type        = string
  default     = ""
}

variable "jupyterhub_proxy_secret_token" {
  description = "Secret token for JupyterHub proxy"
  type        = string
  default     = ""
}
