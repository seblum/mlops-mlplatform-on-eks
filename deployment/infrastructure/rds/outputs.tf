output "rds_host" {
  value = aws_db_instance.rds_instance.address
}

output "rds_username" {
  value = aws_db_instance.rds_instance.username
}

output "rds_password" {
  value = aws_db_instance.rds_instance.password
}

output "rds_dbname" {
  value = aws_db_instance.rds_instance.db_name
}
