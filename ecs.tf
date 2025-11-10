resource "aws_ecs_cluster" "pothole_detection_cluster" {
  name = "pothole-detection-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    project = var.tag
  }
}

resource "aws_ecs_task_definition" "pothole_detection_task" {
  family                   = "pothole-detection-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "pothole-detection-api"
      image     = "ghcr.io/4-nodes/pothole-detection_dotnet:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      repositoryCredentials = { credentialsParameter = data.aws_secretsmanager_secret.ghcr_token.arn }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/pothole-detection"
          awslogs-region        = "af-south-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Allow inbound traffic from ALB and outbound to internet"
  vpc_id      = aws_vpc.pothole_detection_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "pothole_detection_service" {
  name            = "pothole-detection-service"
  cluster         = aws_ecs_cluster.pothole_detection_cluster.id
  task_definition = aws_ecs_task_definition.pothole_detection_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.pothole_detection_ecs_subnet_a.id,
      aws_subnet.pothole_detection_ecs_subnet_b.id
    ]
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs_service_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api_tg.arn
    container_name   = "pothole-detection-api"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.api_listener]
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = aws_vpc.pothole_detection_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "api_alb" {
  name               = "pothole-api-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.pothole_detection_public_subnet_a.id,
    aws_subnet.pothole_detection_public_subnet_b.id
  ]
}

resource "aws_lb_target_group" "api_tg" {
  name        = "pothole-api-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.pothole_detection_vpc.id
  target_type = "ip"
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "api_listener" {
  load_balancer_arn = aws_lb.api_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_tg.arn
  }
}

