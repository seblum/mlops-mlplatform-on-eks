output "rds_host" {
  description = "RDS host for Airflow"
  value       = module.rds-airflow.rds_host
}
