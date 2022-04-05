//S3

variable "S3_bucket_name_usecase" {
    type = string
}

variable "S3_versioning_usecase" {
    type = bool
}

//IAM

variable "IAM_role" {
  type = string
}

variable "IAM_role_attachment_name"{
  type = string
}

variable "IAM_policy" {
  type = string
}

variable "IAM_policy_description" {
  type = string
}

//ECS

variable "cluster_map" {
  type = map(object({
    cluster_name = string
    containerInsights = string
    capacity_providers = list(string)
  }))
}

//Secrets

variable "domain" {
    type = string
}

variable "env" {
    type = string
}

//ECS Task

variable "image_name"{
  type = string
}