# Apply default tags to all AWS resources
provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = var.AWS_DEFAULT_REGION
  skip_credentials_validation = true #delete
  skip_metadata_api_check     = true #delete
  skip_requesting_account_id  = true #delete

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
  instance_type = var.instance_type
  subnet_id       = var.subnet_id
  associate_public_ip = var.associate_public_ip
  security_group_ids = var.security_group_ids
  key_name      = var.key_name
  s3_bucket_name      = var.s3_bucket_name
  s3_bucket_id  = module.s3.bucket_id
  s3_bucket_arn  = module.s3.bucket_arn
}

# --- Lambda: Process Data ---
module "lambda_process" {
  source        = "./modules/lambda_process"
  project_name  = var.project_name
  environment   = var.environment
  s3_bucket_id  = module.s3.bucket_id
  s3_bucket_name      = var.s3_bucket_name  
  s3_bucket_arn  = module.s3.bucket_arn
  lambda_handler = var.lambda_handler
  lambda_runtime = var.lambda_runtime
  lambda_timeout = var.lambda_timeout
  lambda_memory = var.lambda_memory
}

# --- Lambda: Train Model ---
module "lambda_train" {
  source        = "./modules/lambda_train"
  project_name  = var.project_name
  environment   = var.environment
  s3_bucket_id  = module.s3.bucket_id
  s3_bucket_name      = var.s3_bucket_name
  s3_bucket_arn  = module.s3.bucket_arn
  lambda_handler = var.lambda_handler
  lambda_runtime = var.lambda_runtime
  lambda_timeout = var.lambda_timeout
  lambda_memory = var.lambda_memory
}

# --- Lambda: Predict ---
module "lambda_predict" {
  source        = "./modules/lambda_predict"
  project_name  = var.project_name
  environment   = var.environment
  s3_bucket_id  = module.s3.bucket_id
  s3_bucket_name      = var.s3_bucket_name
  s3_bucket_arn  = module.s3.bucket_arn
  lambda_handler = var.lambda_handler
  lambda_runtime = var.lambda_runtime
  lambda_timeout = var.lambda_timeout
  lambda_memory = var.lambda_memory
}