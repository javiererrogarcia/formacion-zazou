
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

resource "aws_secretsmanager_secret" "mwaa_secret" {
  name                = "${var.domain}/${var.env}"
}