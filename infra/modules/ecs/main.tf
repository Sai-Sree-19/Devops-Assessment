#####################################
# CloudWatch Log Group
#####################################

resource "aws_cloudwatch_log_group" "ecs" {

  name              = "/ecs/${var.project_name}-${var.environment}"
  retention_in_days = 7
}

#####################################
# ECS Cluster
#####################################

resource "aws_ecs_cluster" "this" {

  name = "${var.project_name}-${var.environment}-cluster"
}

#####################################
# IAM Role
#####################################

resource "aws_iam_role" "ecs_execution_role" {

  name = "${var.project_name}-${var.environment}-ecs-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {

  role = aws_iam_role.ecs_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#####################################
# Application Load Balancer
#####################################

resource "aws_lb" "this" {

  name = "${var.project_name}-${var.environment}-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group
  ]

  subnets = var.public_subnets
}

#####################################
# Target Group
#####################################

resource "aws_lb_target_group" "this" {

  name = "${var.project_name}-tg"

  port = var.container_port

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {

    path = "/"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2
  }
}

#####################################
# ALB Listener
#####################################

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.this.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.this.arn
  }
}

#####################################
# ECS Task Definition
#####################################

resource "aws_ecs_task_definition" "this" {

  family = "${var.project_name}-${var.environment}"

  network_mode = "awsvpc"

  requires_compatibilities = [
    "FARGATE"
  ]

  cpu = var.cpu

  memory = var.memory

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([

    {

      name = "app"

      image = var.container_image

      essential = true

      portMappings = [

        {

          containerPort = var.container_port

          hostPort = var.container_port

          protocol = "tcp"
        }

      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group = aws_cloudwatch_log_group.ecs.name

          awslogs-region = "us-east-1"

          awslogs-stream-prefix = "ecs"
        }
      }
    }

  ])
}

#####################################
# ECS Service
#####################################

resource "aws_ecs_service" "this" {

  name = "${var.project_name}-${var.environment}-service"

  cluster = aws_ecs_cluster.this.id

  task_definition = aws_ecs_task_definition.this.arn

  desired_count = var.desired_count

  launch_type = "FARGATE"

  network_configuration {

    subnets = var.private_subnets

    security_groups = [

      var.ecs_security_group
    ]

    assign_public_ip = false
  }

  load_balancer {

    target_group_arn = aws_lb_target_group.this.arn

    container_name = "app"

    container_port = var.container_port
  }

  depends_on = [

    aws_lb_listener.http
  ]
}
