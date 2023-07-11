output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

# output "rds_host" {
#   description = "Kubernetes Cluster Name"
#   value       = module.airflow.rds_host
# }

output "eks_managed_node_groups_autoscaling_group_names" {
  value = module.eks.eks_managed_node_groups_autoscaling_group_names
}


output "airflow-profiles" {
  value = local.airflow_profiles
}

