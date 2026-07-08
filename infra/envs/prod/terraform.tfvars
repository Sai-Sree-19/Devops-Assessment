project_name = "hotel"

environment = "dev"

vpc_cidr = "10.0.0.0/16"

public_subnet_1_cidr = "10.0.1.0/24"

public_subnet_2_cidr = "10.0.2.0/24"

private_subnet_1_cidr = "10.0.11.0/24"

private_subnet_2_cidr = "10.0.12.0/24"

database_subnet_1_cidr = "10.0.21.0/24"

database_subnet_2_cidr = "10.0.22.0/24"

availability_zone_1 = "us-east-1a"

availability_zone_2 = "us-east-1b"

db_name = "hoteldb"

db_username = "postgres"

db_password = "Password123!"

instance_class = "db.t3.micro"

allocated_storage = 20

backup_retention_period = 3

deletion_protection = false

container_image = "nginx:latest"

container_port = 80

cpu = 256

memory = 512

desired_count = 1
