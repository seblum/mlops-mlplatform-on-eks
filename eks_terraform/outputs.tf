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
