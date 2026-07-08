module "network" {

  source = "../../modules/network"

  project_name = var.project_name

  environment = var.environment

  vpc_cidr = var.vpc_cidr

  public_subnet_1_cidr = var.public_subnet_1_cidr

  public_subnet_2_cidr = var.public_subnet_2_cidr

  private_subnet_1_cidr = var.private_subnet_1_cidr

  private_subnet_2_cidr = var.private_subnet_2_cidr

  database_subnet_1_cidr = var.database_subnet_1_cidr

  database_subnet_2_cidr = var.database_subnet_2_cidr

  availability_zone_1 = var.availability_zone_1

  availability_zone_2 = var.availability_zone_2
}

module "rds" {

  source = "../../modules/rds"

  project_name = var.project_name

  environment = var.environment

  database_subnets = module.network.database_subnets

  rds_security_group = module.network.rds_security_group

  db_name = var.db_name

  db_username = var.db_username

  db_password = var.db_password

  instance_class = var.instance_class

  allocated_storage = var.allocated_storage

  backup_retention_period = var.backup_retention_period

  deletion_protection = var.deletion_protection
}

module "ecs" {

  source = "../../modules/ecs"

  project_name = var.project_name

  environment = var.environment

  vpc_id = module.network.vpc_id

  public_subnets = module.network.public_subnets

  private_subnets = module.network.private_subnets

  alb_security_group = module.network.alb_security_group

  ecs_security_group = module.network.ecs_security_group

  container_image = var.container_image

  container_port = var.container_port

  cpu = var.cpu

  memory = var.memory

  desired_count = var.desired_count
}
