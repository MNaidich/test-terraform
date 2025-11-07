# Project name prefix 
variable "project_name" {
  description = "Prefix used for consistent resource naming"
  type        = string
}

# Environment name 
variable "environment" {
  description = "Deployment environment for the S3 bucket"
  type        = string
}