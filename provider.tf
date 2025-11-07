terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS provider configuration
#provider "aws" {
#  region  = var.aws_region    # AWS region where resources will be created
#  profile = var.aws_profile   # Local AWS CLI profile (optional)
#}