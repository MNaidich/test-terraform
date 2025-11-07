#############################
# --- AWS Configuration ---
#############################
variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "default"
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS access key ID (for Terraform Cloud environment)"
  type        = string
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS secret access key (for Terraform Cloud environment)"
  type        = string
  sensitive   = true
}

variable "AWS_DEFAULT_REGION" {
  type = string
}


#############################
# --- Project Metadata ---
#############################
variable "project_name" {
  description = "Project name prefix for consistent resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

#############################
# --- Default Tags ---
#############################
variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
}

#############################
# --- EC2 Configuration ---
#############################
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key name for EC2 instance access"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where EC2 instance will be launched"
  type        = string
  default     = ""
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the EC2 instance"
  type        = list(string)
  default     = []
}

#############################
# --- Lambda Configuration ---
#############################
variable "lambda_process_path" {
  description = "Path to the process Lambda source code directory"
  type        = string
}

variable "lambda_train_path" {
  description = "Path to the training Lambda source code directory"
  type        = string
}

variable "lambda_predict_path" {
  description = "Path to the prediction Lambda source code directory"
  type        = string
}

variable "lambda_handler" {
  description = "Lambda handler (entry point)"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description = "Lambda runtime environment"
  type        = string
  default     = "python3.11"
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 60
}

variable "lambda_memory" {
  description = "Lambda memory size (MB)"
  type        = number
  default     = 256
}

#############################
# --- S3 Configuration ---
#############################
variable "s3_bucket_name" {
  description = "Globally unique S3 bucket name for the project"
  type        = string
}
