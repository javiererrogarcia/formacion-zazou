terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

# Deploy cluster list
resource "aws_ecs_cluster" "ecs_clusters" {
  for_each = var.cluster_map
  name = each.value.cluster_name
  capacity_providers = each.value.capacity_providers
  setting {
    name  = "containerInsights"
    value = each.value.containerInsights
  }
  lifecycle {
    create_before_destroy = true
  }
}