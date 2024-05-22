locals {
  name_suffix = "_tf_state"
}

# Create S3 Bucket for TF Backend
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.project_name + local.name_suffix
}
resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create Dynamo DB Table for TF Backend
resource "aws_dynamodb_table" "terraform_state" {
  name         = var.project_name + local.name_suffix
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
