# 1. S3 Bucket Resource
resource "aws_s3_bucket" "this" {
  bucket = "${var.project_name}-${var.environment}-bucket"

  tags = {
    Name        = "${var.project_name}-s3"
    Environment = var.environment
  }
}

# 2. Public Access Block (Security Best Practice)
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 3. Enable Versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 4. Create Folder Structure
locals {
  folders = ["input/", "processed/", "model/", "output/", "app/"]
}

resource "aws_s3_object" "folders" {
  for_each      = toset(local.folders)
  bucket        = aws_s3_bucket.this.id
  key           = each.key
  content_type  = "binary/octet-stream"
}