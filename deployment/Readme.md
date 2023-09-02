## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.11.0 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | 2.3.2 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.10.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.22.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.11.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_airflow"></a> [airflow](#module\_airflow) | ./modules/airflow | n/a |
| <a name="module_dashboard"></a> [dashboard](#module\_dashboard) | ./modules/dashboard | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ./infrastructure/eks | n/a |
| <a name="module_jupyterhub"></a> [jupyterhub](#module\_jupyterhub) | ./modules/jupyterhub | n/a |
| <a name="module_mlflow"></a> [mlflow](#module\_mlflow) | ./modules/mlflow | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_networking"></a> [networking](#module\_networking) | ./infrastructure/networking | n/a |
| <a name="module_sagemaker"></a> [sagemaker](#module\_sagemaker) | ./modules/sagemaker | n/a |
| <a name="module_user-profiles"></a> [user-profiles](#module\_user-profiles) | ./modules/user-profiles | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./infrastructure/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.random_prefix](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_AWS_ACCESS_KEY"></a> [AWS\_ACCESS\_KEY](#input\_AWS\_ACCESS\_KEY) | AWS access key id | `string` | `""` | no |
| <a name="input_AWS_REGION"></a> [AWS\_REGION](#input\_AWS\_REGION) | AWS region | `string` | `"eu-central-1"` | no |
| <a name="input_AWS_SECRET_KEY"></a> [AWS\_SECRET\_KEY](#input\_AWS\_SECRET\_KEY) | AWS secret access key | `string` | `""` | no |
| <a name="input_airflow_fernet_key"></a> [airflow\_fernet\_key](#input\_airflow\_fernet\_key) | Fernet key for Airflow encryption | `string` | `""` | no |
| <a name="input_airflow_git_client_id"></a> [airflow\_git\_client\_id](#input\_airflow\_git\_client\_id) | Client ID for Airflow Git integration | `string` | `""` | no |
| <a name="input_airflow_git_client_secret"></a> [airflow\_git\_client\_secret](#input\_airflow\_git\_client\_secret) | Client secret for Airflow Git integration | `string` | `""` | no |
| <a name="input_airflow_github_ssh"></a> [airflow\_github\_ssh](#input\_airflow\_github\_ssh) | SSH key for Airflow GitHub repository | `string` | `""` | no |
| <a name="input_deploy_airflow"></a> [deploy\_airflow](#input\_deploy\_airflow) | Should Airflow be deployed? | `bool` | `true` | no |
| <a name="input_deploy_dashboard"></a> [deploy\_dashboard](#input\_deploy\_dashboard) | Should the dashboard be deployed? | `bool` | `true` | no |
| <a name="input_deploy_jupyterhub"></a> [deploy\_jupyterhub](#input\_deploy\_jupyterhub) | Should JupyterHub be deployed? | `bool` | `true` | no |
| <a name="input_deploy_mlflow"></a> [deploy\_mlflow](#input\_deploy\_mlflow) | Should MLflow be deployed? | `bool` | `true` | no |
| <a name="input_deploy_monitoring"></a> [deploy\_monitoring](#input\_deploy\_monitoring) | Should monitoring be deployed? | `bool` | `true` | no |
| <a name="input_deploy_sagemaker"></a> [deploy\_sagemaker](#input\_deploy\_sagemaker) | Should Seldon Core be deployed? | `bool` | `true` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for deployment | `string` | `""` | no |
| <a name="input_git_sync_branch"></a> [git\_sync\_branch](#input\_git\_sync\_branch) | Name of the git branch of the Airflow DAG repository | `string` | `""` | no |
| <a name="input_git_sync_repository_url"></a> [git\_sync\_repository\_url](#input\_git\_sync\_repository\_url) | Https git url to the Airflow DAG repository | `string` | `""` | no |
| <a name="input_git_token"></a> [git\_token](#input\_git\_token) | Token for Git authentication | `string` | `""` | no |
| <a name="input_git_username"></a> [git\_username](#input\_git\_username) | Username for Git authentication | `string` | `""` | no |
| <a name="input_grafana_git_client_id"></a> [grafana\_git\_client\_id](#input\_grafana\_git\_client\_id) | Client ID for Grafana Git integration | `string` | `""` | no |
| <a name="input_grafana_git_client_secret"></a> [grafana\_git\_client\_secret](#input\_grafana\_git\_client\_secret) | Client secret for Grafana Git integration | `string` | `""` | no |
| <a name="input_jupyterhub_git_client_id"></a> [jupyterhub\_git\_client\_id](#input\_jupyterhub\_git\_client\_id) | Client ID for JupyterHub Git integration | `string` | `""` | no |
| <a name="input_jupyterhub_git_client_secret"></a> [jupyterhub\_git\_client\_secret](#input\_jupyterhub\_git\_client\_secret) | Client secret for JupyterHub Git integration | `string` | `""` | no |
| <a name="input_jupyterhub_proxy_secret_token"></a> [jupyterhub\_proxy\_secret\_token](#input\_jupyterhub\_proxy\_secret\_token) | Secret token for JupyterHub proxy | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_airflow_variable_list"></a> [airflow\_variable\_list](#output\_airflow\_variable\_list) | n/a |
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | AWS region |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Kubernetes Cluster Name |
| <a name="output_developers_user_access_auth_list"></a> [developers\_user\_access\_auth\_list](#output\_developers\_user\_access\_auth\_list) | List of users that are added as aws\_auth\_users to eks |
