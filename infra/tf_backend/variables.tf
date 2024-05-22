variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "The name of the project. Used for naming of S3 bucket and Dynamo DB"
  type        = string
  nullable    = false
}
