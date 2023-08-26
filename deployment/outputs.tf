output "airflow_profiles" {
  description = "Airflow profiles"
  value       = local.airflow_profiles
}

output "aws_region" {
  description = "AWS region"
  value       = local.aws_region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "eks_managed_node_groups_autoscaling_group_names" {
  description = "List of managed node groups' autoscaling group names in the EKS cluster"
  value       = module.eks.eks_managed_node_groups_autoscaling_group_names
}

output "jupyterhub_admin_user_list" {
  description = "List of admin users in JupyterHub"
  value       = local.jupyterhub_admin_user_list
}

output "jupyterhub_allowed_user_list" {
  description = "List of allowed users in JupyterHub"
  value       = local.jupyterhub_allowed_user_list
}

# output "rds_host" {
#   description = "Kubernetes Cluster Name"
#   value       = module.airflow.rds_host
# }

