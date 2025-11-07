# AWS region and CLI profile
variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use for authentication (optional)"
  type        = string
  default     = "default"
}

# General project naming
variable "project_name" {
  description = "Prefix used for naming resources consistently"
  type        = string
  default     = "demand-forecasting"
}

# Environment
variable "environment" {
  description = "Environment for resource deployment"
  type        = string
  default     = "prod"
}

# Tags applied to all resources
variable "default_tags" {
  description = "Default tags to be applied to all resources"
  type        = map(string)
  default = {
    Owner       = "ITTeam"
    ManagedBy   = "Terraform"
    Environment = "prod"
  }
}