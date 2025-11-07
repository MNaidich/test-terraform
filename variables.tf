# AWS Configuration
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = null
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS access key for Terraform Cloud authentication"
  type        = string
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS secret key for Terraform Cloud authentication"
  type        = string
  sensitive   = true
}

# EC2 Configuration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instance"
  type        = string
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP with the instance"
  type        = bool
}

variable "security_group_ids" {
  description = "List of security group IDs for EC2"
  type        = list(string)
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

# Lambda configuration
variable "lambda_runtime" {
  description = "Runtime for Lambda functions"
  type        = string
}

variable "lambda_handler" {
  description = "Handler for Lambda functions"
  type        = string
}

variable "lambda_timeout" {
  description = "Timeout for Lambda functions"
  type        = number
}

variable "lambda_memory" {
  description = "Memory for Lambda functions"
  type        = number
}

# Paths for Lambda source code
variable "lambda_process_path" {
  description = "Path to the Lambda Process function code"
  type        = string
}

variable "lambda_train_path" {
  description = "Path to the Lambda Train function code"
  type        = string
}

variable "lambda_predict_path" {
  description = "Path to the Lambda Predict function code"
  type        = string
}