# --- S3 Outputs ---
output "s3_bucket_name" {
  description = "Name of the S3 bucket used for data and model storage"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}

# --- EC2 Outputs ---
output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = module.ec2.public_dns
}

# --- Lambda: Process Data ---
output "lambda_process_name" {
  description = "Lambda function name for data processing"
  value       = module.lambda_process.lambda_name
}

# --- Lambda: Train Model ---
output "lambda_train_name" {
  description = "Lambda function name for model training"
  value       = module.lambda_train.lambda_name
}

# --- Lambda: Predict ---
output "lambda_predict_name" {
  description = "Lambda function name for model prediction"
  value       = module.lambda_predict.lambda_name
}
