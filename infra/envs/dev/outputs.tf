output "alb_dns" {

  value = module.ecs.alb_dns_name
}

output "database_endpoint" {

  value = module.rds.db_endpoint
}
