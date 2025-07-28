output "release_name" {
  description = "Helm release name"
  value       = helm_release.external_secrets.name
}

output "namespace" {
  description = "Kubernetes namespace where operator is deployed"
  value       = helm_release.external_secrets.namespace
}
