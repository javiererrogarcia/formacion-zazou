terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  region     = "eu-central-1"
  access_key = ""
  secret_key = ""
}

data "aws_region" "current" {}

module "s3_data_bucket"{
    source = "./s3"
    S3_bucket_name_usecase = var.S3_bucket_name_usecase
    S3_versioning_usecase = var.S3_versioning_usecase
}

module "ecs" {
  source = "./ecs"
  cluster_map = var.cluster_map
}


module "iam"{
    source = "./iam"
    depends_on = [module.s3_data_bucket]
    IAM_policy = var.IAM_policy
    IAM_policy_description = var.IAM_policy_description
    IAM_role = var.IAM_role
    IAM_role_attachment_name = var.IAM_role_attachment_name
    s3_bucket = module.s3_data_bucket.s3_bucket
}


module "secrets-manager"{
    source = "./secrets-manager"
    domain = var.domain
    env = var.env

}

module "ecs-task"{
    source = "./ecs-task"
    depends_on = [module.iam]
    image_name = var.image_name
    task_role = module.iam.iam_role_arn
}

