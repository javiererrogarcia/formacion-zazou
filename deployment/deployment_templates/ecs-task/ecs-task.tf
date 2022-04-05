terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}


resource "aws_ecs_task_definition" "zazou-thunderchild" {
    family = "thunderchild-formacion"
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
    task_role_arn = var.task_role
    cpu = 1024
    memory = 2048
    container_definitions = jsonencode([
    {
        name      = "thunderchild-formacion"
        image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${var.image_name}:latest"
        essential = true
        portMappings = [
            {
            containerPort = 3333
            hostPort      = 3333
            }
        ]
        }
    ])
}