##################################
# VPC
##################################

resource "aws_vpc" "this" {

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

##################################
# Internet Gateway
##################################

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

##################################
# Public Subnet 1
##################################

resource "aws_subnet" "public1" {

  vpc_id = aws_vpc.this.id

  cidr_block = var.public_subnet_1_cidr

  availability_zone = var.availability_zone_1

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-1"
  }
}

##################################
# Public Subnet 2
##################################

resource "aws_subnet" "public2" {

  vpc_id = aws_vpc.this.id

  cidr_block = var.public_subnet_2_cidr

  availability_zone = var.availability_zone_2

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-2"
  }
}

##################################
# Private App Subnet 1
##################################

resource "aws_subnet" "private1" {

  vpc_id = aws_vpc.this.id

  cidr_block = var.private_subnet_1_cidr

  availability_zone = var.availability_zone_1

  tags = {
    Name = "${var.project_name}-private-app-1"
  }
}

##################################
# Private App Subnet 2
##################################

resource "aws_subnet" "private2" {

  vpc_id = aws_vpc.this.id

  cidr_block = var.private_subnet_2_cidr

  availability_zone = var.availability_zone_2

  tags = {
    Name = "${var.project_name}-private-app-2"
  }
}

##################################
# Database Subnet 1
##################################

resource "aws_subnet" "database1" {

  vpc_id = aws_vpc.this.id

  cidr_block = var.database_subnet_1_cidr

  availability_zone = var.availability_zone_1

  tags = {
    Name = "${var.project_name}-database-1"
  }
}

##################################
# Database Subnet 2
##################################

resource "aws_subnet" "database2" {

  vpc_id = aws_vpc.this.id

  cidr_block = var.database_subnet_2_cidr

  availability_zone = var.availability_zone_2

  tags = {
    Name = "${var.project_name}-database-2"
  }
}

##################################
# Elastic IP
##################################

resource "aws_eip" "nat" {

  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

##################################
# NAT Gateway
##################################

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public1.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = "${var.project_name}-nat"
  }
}

##################################
# Public Route Table
##################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.this.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

##################################
# Private Route Table
##################################

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.this.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

##################################
# Route Associations
##################################

resource "aws_route_table_association" "public1" {

  subnet_id = aws_subnet.public1.id

  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {

  subnet_id = aws_subnet.public2.id

  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {

  subnet_id = aws_subnet.private1.id

  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {

  subnet_id = aws_subnet.private2.id

  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database1" {

  subnet_id = aws_subnet.database1.id

  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database2" {

  subnet_id = aws_subnet.database2.id

  route_table_id = aws_route_table.private.id
}

##################################
# ALB Security Group
##################################

resource "aws_security_group" "alb" {

  name = "${var.project_name}-alb-sg"

  description = "ALB Security Group"

  vpc_id = aws_vpc.this.id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################################
# ECS Security Group
##################################

resource "aws_security_group" "ecs" {

  name = "${var.project_name}-ecs-sg"

  vpc_id = aws_vpc.this.id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]
  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################################
# RDS Security Group
##################################

resource "aws_security_group" "rds" {

  name = "${var.project_name}-rds-sg"

  vpc_id = aws_vpc.this.id

  ingress {

    from_port = 5432

    to_port = 5432

    protocol = "tcp"

    security_groups = [
      aws_security_group.ecs.id
    ]
  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}
