# Tripare DevOps Assignment

## Overview
This project demonstrates a simple DevOps setup using:

- Terraform (Infrastructure as Code)
- Reusable Terraform modules
- Separate Dev and Prod environments
- Docker Compose
- PostgreSQL
- Bash scripts for database backup and restore

## Project Structure
Tripare-Devops-Assignment/
├── infra/
│   ├── modules/
│   └── envs/
├── database/
├── scripts/
├── docker-compose.yml
└── README.md

## Prerequisites

Make sure the following tools are installed:
- Terraform
- Docker & Docker Compose
- PostgreSQL Client (psql & pg_dump)
- Git

## Terraform
The Terraform code is organized into reusable modules with separate configurations for **dev** and **prod** environments.
Go to the required environment:

cd infra/envs/dev
**Run:**
terraform fmt
terraform init
terraform validate
terraform plan -refresh=false

Repeat the same steps for the **prod** environment if needed.

## Database
Start the PostgreSQL container:
--docker compose up -d
Check the running container:
--docker ps

## Backup Database
./scripts/backup.sh

This creates a backup of the PostgreSQL database.

## Restore Database
./scripts/restore.sh

This restores the database from the backup file.

## Review Commands

Terraform:
terraform fmt
terraform init
terraform validate
terraform plan -refresh=false

**Database:**
docker compose up
./scripts/backup.sh
./scripts/restore.sh

## Technologies Used

- Terraform
- Docker
- Docker Compose
- PostgreSQL
- Bash
- Git
## Notes

- Terraform is organized using reusable modules.
- Separate configurations are maintained for Dev and Prod environments.
- Docker Compose is used to run PostgreSQL locally.
- Backup and restore operations are automated using shell scripts.
