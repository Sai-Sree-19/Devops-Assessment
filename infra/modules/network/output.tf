output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]
}

output "private_subnets" {
  value = [
    aws_subnet.private1.id,
    aws_subnet.private2.id
  ]
}

output "database_subnets" {
  value = [
    aws_subnet.database1.id,
    aws_subnet.database2.id
  ]
}

output "alb_security_group" {
  value = aws_security_group.alb.id
}

output "ecs_security_group" {
  value = aws_security_group.ecs.id
}

output "rds_security_group" {
  value = aws_security_group.rds.id
}
