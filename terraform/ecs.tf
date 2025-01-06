resource "aws_ecs_cluster" "main" {
    name = var.app_name
}

resource "aws_ecs_task_definition" "app" {
  family                   = var.app_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode(
    [
      {
        "name": "${var.app_name}",
        "image": "261219435789.dkr.ecr.${var.aws_region}.amazonaws.com/${var.app_name}:latest",
        "memory": 512,
        "cpu": 256,
        "portMappings": [
          {
            "containerPort": 8000,
            "hostPort": 8000,
            "protocol": "tcp"
          }
        ],
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "/ecs/${var.app_name}",
            "awslogs-region": "${var.aws_region}",
            "awslogs-stream-prefix": "ecs"
          }
        }
      }
    ]
  )
}



resource "aws_ecs_service" "app" {
    name = var.app_name
    cluster = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.app.arn
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
      subnets = aws_subnet.default[*].id
      security_groups = [aws_security_group.app.id]
      assign_public_ip = true
    }
}