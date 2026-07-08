###########################################
# DB Subnet Group
###########################################

resource "aws_db_subnet_group" "this" {

  name = "${var.project_name}-${var.environment}-db-subnet-group"

  subnet_ids = var.database_subnets

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

###########################################
# PostgreSQL Parameter Group
###########################################

resource "aws_db_parameter_group" "postgres" {

  name   = "${var.project_name}-${var.environment}-postgres"
  family = "postgres15"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-postgres-params"
  }
}

###########################################
# PostgreSQL RDS Instance
###########################################

resource "aws_db_instance" "postgres" {

  identifier = "${var.project_name}-${var.environment}-postgres"

  engine = "postgres"

  engine_version = "15.5"

  instance_class = var.instance_class

  allocated_storage = var.allocated_storage

  storage_type = "gp3"

  db_name = var.db_name

  username = var.db_username

  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.this.name

  parameter_group_name = aws_db_parameter_group.postgres.name

  vpc_security_group_ids = [
    var.rds_security_group
  ]

  publicly_accessible = false

  skip_final_snapshot = true

  backup_retention_period = var.backup_retention_period

  deletion_protection = var.deletion_protection

  multi_az = false

  auto_minor_version_upgrade = true

  apply_immediately = true

  storage_encrypted = true

  tags = {
    Name = "${var.project_name}-${var.environment}-postgres"
  }
}
