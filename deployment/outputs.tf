output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "developers_user_access_auth_list" {
  description = "List of users that are added as aws_auth_users to eks"
  value       = local.developers_user_access_auth_list
}

# output "eks_managed_node_groups_autoscaling_group_names" {
#   description = "List of managed node groups' autoscaling group names in the EKS cluster"
#   value       = module.eks.eks_managed_node_groups_autoscaling_group_names
# }

output "airflow_variable_list" {
  description = "List of Variables added to the Airflow deployments as Airflow Variables"
  value = local.airflow_variable_list
}
