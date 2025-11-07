# Bucket name (string)
output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.this.bucket
}

# Bucket ARN (Amazon Resource Name)
output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.this.arn
}

# Bucket ID (useful for referencing in other modules)
output "bucket_id" {
  description = "Unique ID of the created S3 bucket"
  value       = aws_s3_bucket.this.id
}
