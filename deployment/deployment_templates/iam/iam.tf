terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"

}


data "aws_region" "current" {}

data "aws_caller_identity" "current" {}


resource "aws_iam_role" "role" {
  name = var.IAM_role

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ecs.amazonaws.com"]
          AWS = "523961930851"
        }
      },
    ]
  })
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_iam_policy" "policy" {
  depends_on = [
    aws_iam_role.role
  ]
  name        = var.IAM_policy
  description = var.IAM_policy_description

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ecs:*",
            "Resource": [
                "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:task-definition/*",
                "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:task/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:*"
            ],
            "Resource": [
                "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:**"
            ]
        },
        {
            "Action": [
                "iam:PassRole",
                "iam:GetRole"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"
            ]
        }
    ]
}
EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy_attachment" "policy_attach" {
  depends_on = [
    aws_iam_policy.policy
  ]
  name       = "policy_attachment"
  roles      = [aws_iam_role.role.name]
  policy_arn = aws_iam_policy.policy.arn
}


output "iam_role_arn" {
  value = aws_iam_role.role.arn
}