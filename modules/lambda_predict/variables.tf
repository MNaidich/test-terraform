variable "s3_bucket_name" {
  description = "Name of the main S3 bucket used for forecasting data and outputs."
  type        = string
}

variable "lambda_process_path" {
  description = "Local path to the source code for the predictor Lambda."
  type        = string
  default     = "lambda_src/forecaster"
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