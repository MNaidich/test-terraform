# 1. IAM ROLE DEFINITION ---
resource "aws_iam_role" "lambda_predictor_role" {
  name = "lambda-predictor-role"

  # Trust policy: allow Lambda service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

# 2. POLICY ATTACHMENTS 

# CloudWatch Logs (basic Lambda execution)
resource "aws_iam_role_policy_attachment" "predictor_log_policy_attach" {
  role       = aws_iam_role.lambda_predictor_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# S3 Full Access (custom policy local to this module)
resource "aws_iam_policy" "lambda_s3_full_access_policy" {
  name        = "${var.project_name}-${var.environment}-lambda-predict-s3-policy"
  description = "Allows the Lambda predictor function to access the project S3 bucket."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:*"],
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "predictor_s3_attach" {
  role       = aws_iam_role.lambda_predictor_role.name
  policy_arn = aws_iam_policy.lambda_s3_full_access_policy.arn
}

# Custom policy for invoking SageMaker endpoints
resource "aws_iam_policy" "sagemaker_predict_policy" {
  name        = "${var.project_name}-${var.environment}-sagemaker-predict-policy"
  description = "Allows the Lambda to invoke SageMaker endpoints for prediction."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sagemaker:InvokeEndpoint",
        Resource = "*" # can be restricted to a specific endpoint ARN if required
      }
    ]
  })
}

# Attach SageMaker policy to the role
resource "aws_iam_role_policy_attachment" "predictor_sagemaker_attach" {
  role       = aws_iam_role.lambda_predictor_role.name
  policy_arn = aws_iam_policy.sagemaker_predict_policy.arn
}


# 3. LAMBDA FUNCTION DEFINITION

# Package the Lambda source code
data "archive_file" "predictor_zip" {
  type        = "zip"
  source_dir  = var.lambda_predict_path
  output_path = "${path.module}/lambda_zips/predictor.zip"
}

# Define the Lambda function
resource "aws_lambda_function" "forecasting_predictor" {
  function_name    = "${var.project_name}-${var.environment}-forecasting-predictor"
  filename         = data.archive_file.predictor_zip.output_path
  source_code_hash = data.archive_file.predictor_zip.output_base64sha256
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory

  role             = aws_iam_role.lambda_predictor_role.arn
  
  environment {
    variables = {
      S3_BUCKET_NAME = var.s3_bucket_name
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.predictor_log_policy_attach,
    aws_iam_role_policy_attachment.predictor_s3_attach,
    aws_iam_role_policy_attachment.predictor_sagemaker_attach
  ]
}


# 4. TRIGGER 1: S3 (processed/ folder updates)
resource "aws_lambda_permission" "allow_s3_invoke_predict" {
  statement_id  = "AllowExecutionFromS3Processed"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.forecasting_predictor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}

resource "aws_s3_bucket_notification" "processed_file_trigger" {
  bucket = var.s3_bucket_id

  lambda_function {
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "processed/"
    lambda_function_arn = aws_lambda_function.forecasting_predictor.arn
  }

  depends_on = [
    aws_lambda_permission.allow_s3_invoke_predict
  ]
}


# 5. TRIGGER 2: EventBridge (monthly at 01:00 AM) 
resource "aws_cloudwatch_event_rule" "monthly_predict_rule" {
  name                = "${var.project_name}-${var.environment}-monthly-predict-rule"
  schedule_expression = "cron(0 1 1 * ? *)" # 1 AM, day 1 of each month
}

resource "aws_cloudwatch_event_target" "monthly_predict_target" {
  rule      = aws_cloudwatch_event_rule.monthly_predict_rule.name
  target_id = "PredictorLambda"
  arn       = aws_lambda_function.forecasting_predictor.arn
}

resource "aws_lambda_permission" "allow_eventbridge_invoke_predict" {
  statement_id  = "AllowExecutionFromEventBridgePredict"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.forecasting_predictor.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.monthly_predict_rule.arn
}
