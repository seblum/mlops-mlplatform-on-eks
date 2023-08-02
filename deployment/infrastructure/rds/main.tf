locals {
  rds_name           = var.rds_name
  rds_engine         = var.rds_engine
  rds_engine_version = var.rds_engine_version
  rds_port           = var.rds_port
}

resource "aws_db_subnet_group" "default" {
  name       = "vpc-subnet-group-${local.rds_name}"
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage      = var.max_allocated_storage
  storage_type           = var.storage_type
  engine                 = local.rds_engine
  engine_version         = local.rds_engine_version
  instance_class         = var.rds_instance_class
  db_name                = "${local.rds_name}_db"
  username               = "${local.rds_name}_admin"
  password               = var.rds_password
  identifier             = "${local.rds_name}-${local.rds_engine}"
  port                   = local.rds_port
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  skip_final_snapshot    = true
}

resource "aws_security_group" "rds_sg" {
  name   = "${local.rds_name}-${local.rds_engine}-sg"
  vpc_id = var.vpc_id
  
  ingress {
    description = "Enable postgres access"
    from_port   = local.rds_port
    to_port     = local.rds_port
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
