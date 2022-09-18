resource "aws_db_subnet_group" "default" {
  name       = "vpc-subnet-group-airflow"
  subnet_ids = var.vpc_private_subnets
}

resource "random_password" "password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "airflow" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "13.3"
  instance_class         = "db.t3.micro"
  db_name                = "airflow_db"
  username               = "airflow_admin" # push to main
  password               = random_password.password.result
  parameter_group_name   = "default.postgres13"
  identifier             = "airflow-postgres"
  port                   = 5432
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  skip_final_snapshot    = true
}


resource "aws_security_group" "rds_sg" {
  name   = "airflow-postgres-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "Enable postgres access"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_subnets_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
