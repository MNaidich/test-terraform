# Apply default tags to all AWS resources
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = var.default_tags
  }
}

# --- S3 Module ---
module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  environment  = var.environment
}

# --- EC2 Module ---
module "ec2" {
  source        = "./modules/ec2"
  project_name  = var.project_name
  environment   = var.environment
  instance_type = var.instance_tryp
  subnet_id       = var.subnet_id
  associate_public_ip = var.associate_public_ip
  security_groups_id = var.security_groups_id
  key_name      = var.key_name
  s3_bucket_id  = module.s3.bucket_id
  s3_bucket_arn  = module.s3.bucket_arn
}

# --- Lambda: Process Data ---
module "lambda_process" {
  source        = "./modules/lambda_process"
  project_name  = var.project_name
  environment   = var.environment
  s3_bucket_id  = module.s3.bucket_id
  s3_bucket_name  = module.s3.bucket_name
  s3_bucket_arn  = module.s3.bucket_arn
  lambda_handler = var.lambda_handler
  lambda_runtime = var.lambda_runtime
  lambda_timeout = var.lambda_timeout
  lambda_memory = var.lambda_memory
  role_name     = "lambda-process-role"
}

# --- Lambda: Train Model ---
module "lambda_train" {
  source        = "./modules/lambda_train"
  project_name  = var.project_name
  environment   = var.environment
  s3_bucket_id  = module.s3.bucket_id
  s3_bucket_name  = module.s3.bucket_name
  s3_bucket_arn  = module.s3.bucket_arn
  lambda_handler = var.lambda_handler
  lambda_runtime = var.lambda_runtime
  lambda_timeout = var.lambda_timeout
  lambda_memory = var.lambda_memory
  role_name     = "lambda-train-role"
}

# --- Lambda: Predict ---
module "lambda_predict" {
  source        = "./modules/lambda_predict"
  project_name  = var.project_name
  environment   = var.environment
  s3_bucket_id  = module.s3.bucket_id
  s3_bucket_name  = module.s3.bucket_name
  s3_bucket_arn  = module.s3.bucket_arn
  lambda_handler = var.lambda_handler
  lambda_runtime = var.lambda_runtime
  lambda_timeout = var.lambda_timeout
  lambda_memory = var.lambda_memory
  role_name     = "lambda-predict-role"
}