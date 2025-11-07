variable "project_name" {
  description = "Prefix for consistent naming of Lambda resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for Lambda environment variable"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN for IAM policy"
  type        = string
}

variable "lambda_train_path" {
  description = "Path to the Lambda training code"
  type        = string
  default     = "lambda_src/model_trainer"
}

variable "lambda_handler" {
  description = "Name of the handler file and function (e.g., 'train_model.main')"
  type        = string
  default     = "train_model.main"
}

variable "lambda_runtime" {
  description = "Lambda runtime (Python version)"
  type        = string
  default     = "python3.11"
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds (default: 15 minutes)"
  type        = number
  default     = 900
}

variable "lambda_memory" {
  description = "Lambda memory allocation (MB)"
  type        = number
  default     = 1024
}

variable "schedule_expression" {
  description = "Cron or rate expression for EventBridge trigger"
  type        = string
  default     = "cron(0 0 1 * ? *)" # Run at midnight on the 1st of every month
}
