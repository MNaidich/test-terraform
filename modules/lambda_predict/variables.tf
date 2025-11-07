variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the main S3 bucket used for forecasting data and outputs."
  type        = string
}

variable "s3_bucket_id" {
  description = "ID of the S3 bucket used by the Lambda function"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN del bucket S3 al que la Lambda tendrá acceso"
  type        = string
}

variable "lambda_predict_path" {
  description = "Local folder containing the Lambda function code"
  type        = string
  default     = "lambda_src/lambda_predict"
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