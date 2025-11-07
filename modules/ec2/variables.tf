variable "project_name" {
  description = "Project name prefix for consistent resource naming"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, staging, prod)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for EC2 instance"
  type        = string
  default     = "ami-1234567890abcdef0" # delete variable
}

variable "instance_type" {
  description = "EC2 instance type (e.g., t3.medium)"
  type        = string
  default     = "t3.medium"
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be deployed"
  type        = string
}

variable "associate_public_ip" {
  description = "Whether to assign a public IP address"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to pull the Streamlit app from"
  type        = string
}

variable "s3_bucket_id" {
  description = "The ID of the S3 bucket used by the project"
  type        = string
}

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket used by the project"
  type        = string
}

