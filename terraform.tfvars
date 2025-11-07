# --- AWS Provider Configuration ---
aws_region  = "us-east-1"            
aws_profile = "default" 
AWS_ACCESS_KEY_ID = "fake_access_key"
AWS_SECRET_ACCESS_KEY = "fake_secret_key"        
AWS_DEFAULT_REGION     = us-east-1

# --- Project Metadata ---
project_name = "demand-forecasting"
environment  = "prod"

# --- Default Tags ---
default_tags = {
  Project     = "Demand Forecasting"
  Environment = "Production"
  ManagedBy   = "Terraform"
  Owner       = "Data Science Team"
}

# --- EC2 Configuration ---
instance_type = "t3.medium"
key_name      = "demand-forecasting-instance"
subnet_id = false
associate_public_ip = false
security_group_ids = []

# --- Lambda Source Directories (Local paths for packaging) ---
lambda_process_path = "lambda_src/lambda_process"
lambda_train_path   = "lambda_src/lambda_train"
lambda_predict_path = "lambda_src/lambda_predict"
lambda_handler = "lambda_funtion.lambda_handler"
lambda_runtime = "python3.11"
lambda_timeout = 1000
lambda_memory = 512

# --- S3 Bucket Name (must be globally unique) ---
s3_bucket_name = "demand-forecasting-bucket"