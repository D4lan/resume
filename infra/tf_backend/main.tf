locals {
  name_suffix = "tf-state"
  state_name  = "${var.project_name}-${local.name_suffix}"
}

# Create S3 Bucket for TF Backend
resource "aws_s3_bucket" "terraform_state" {
  bucket = local.state_name
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
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create Dynamo DB Table for TF Backend
resource "aws_dynamodb_table" "terraform_state" {
  name         = local.state_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
