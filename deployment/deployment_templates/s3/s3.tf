terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

resource "aws_s3_bucket" "server_bucket" {
  bucket = var.S3_bucket_name_usecase
}

resource "aws_s3_bucket_versioning" "versioning" {
  depends_on = [
    aws_s3_bucket.server_bucket
  ]
  bucket = aws_s3_bucket.server_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket.server_bucket
  ]
  bucket = aws_s3_bucket.server_bucket.id
  acl    = "private"
}


resource "aws_s3_bucket_public_access_block" "access_s3_data" {
  depends_on = [
    aws_s3_bucket.server_bucket,
  ]
  bucket = aws_s3_bucket.server_bucket.id
  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = true
}

output "s3_bucket" {
  value = aws_s3_bucket.server_bucket.id
}