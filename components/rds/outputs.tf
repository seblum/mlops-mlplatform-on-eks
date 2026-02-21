output "rds_dbname" {
  description = "Name of the RDS database"
  value       = aws_db_instance.rds_instance.db_name
}

output "rds_host" {
  description = "Hostname or endpoint of the RDS instance"
  value       = aws_db_instance.rds_instance.address
}

output "rds_password" {
  description = "Password for the RDS instance"
  value       = aws_db_instance.rds_instance.password
}

output "rds_username" {
  description = "Username for the RDS instance"
  value       = aws_db_instance.rds_instance.username
}
