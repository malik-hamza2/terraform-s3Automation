locals {
  common_tags = {
    Project = var.project
    Owner   = var.owner
  }
}

# S3 Buckets (one per environment)
resource "aws_s3_bucket" "bucket" {
  for_each = var.environments

  bucket        = "${var.bucket_prefix}-${each.key}-${var.bucket_suffix}"
  force_destroy = var.force_destroy

  tags = merge(local.common_tags, {
    Name        = "${var.bucket_prefix}-${each.key}-${var.bucket_suffix}"
    Environment = each.key
  })
}

# Versioning
resource "aws_s3_bucket_versioning" "versioning" {
  for_each = aws_s3_bucket.bucket

  bucket = each.value.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  for_each = aws_s3_bucket.bucket

  bucket = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "public_access" {
  for_each = aws_s3_bucket.bucket

  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Existing dev resources get a new address, no recreate
moved {
  from = aws_s3_bucket.bucket
  to   = aws_s3_bucket.bucket["dev"]
}

moved {
  from = aws_s3_bucket_versioning.versioning
  to   = aws_s3_bucket_versioning.versioning["dev"]
}

moved {
  from = aws_s3_bucket_server_side_encryption_configuration.encryption
  to   = aws_s3_bucket_server_side_encryption_configuration.encryption["dev"]
}

moved {
  from = aws_s3_bucket_public_access_block.public_access
  to   = aws_s3_bucket_public_access_block.public_access["dev"]
}