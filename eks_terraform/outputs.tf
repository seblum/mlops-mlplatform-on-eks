

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "rds_host" {
  description = "Kubernetes Cluster Name"
  value       = module.rds.rds_host
}
