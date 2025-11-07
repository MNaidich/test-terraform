variable "project_name" {
  description = "Prefix for consistent naming of Lambda resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "s3_bucket_id" {
  description = "S3 bucket ID to attach the notification trigger"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for environment variables"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN for IAM policies"
  type        = string
}

variable "lambda_process_path" {
  description = "Local folder containing the Lambda function code"
  type        = string
  default     = "lambda_src/lambda_process"
}

variable "lambda_handler" {
  description = "Name of the Python handler function (e.g., 'app.main')"
  type        = string
  default     = "process_data.main"
}

variable "lambda_runtime" {
  description = "Python runtime version for Lambda"
  type        = string
  default     = "python3.11"
}

variable "lambda_timeout" {
  description = "Lambda execution timeout (seconds)"
  type        = number
  default     = 300
}

variable "lambda_memory" {
  description = "Lambda memory size in MB"
  type        = number
  default     = 512
}