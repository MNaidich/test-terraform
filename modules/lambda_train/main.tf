# 1. IAM Role for the Trainer Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-train-role"

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

# 2. Attach AWS Managed Policy for CloudWatch Logs
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 3. Attach AWS Managed Policy for SageMaker Access
resource "aws_iam_role_policy_attachment" "lambda_sagemaker" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

# 4. Custom Policy for S3 Bucket Access
resource "aws_iam_policy" "lambda_s3_policy" {
  name        = "${var.project_name}-${var.environment}-lambda-train-s3-policy"
  description = "Allows Lambda to access objects in the project S3 bucket."

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

# 5. Attach S3 Policy to the Lambda Role
resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

# 6. Package the Lambda Code
data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = var.lambda_train_path
  output_path = "${path.module}/lambda_package.zip"
}

# 7. Create the Lambda Function
resource "aws_lambda_function" "lambda_train" {
  function_name    = "${var.project_name}-${var.environment}-lambda-train"
  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      S3_BUCKET_NAME = var.s3_bucket_name
    }
  }
}

# 8. EventBridge Rule (Monthly Trigger)
resource "aws_cloudwatch_event_rule" "monthly_train_rule" {
  name                = "${var.project_name}-${var.environment}-monthly-train-rule"
  description         = "Triggers the model training Lambda once per month"
  schedule_expression = var.schedule_expression
}

# 9. Connect EventBridge to the Lambda
resource "aws_cloudwatch_event_target" "train_target" {
  rule      = aws_cloudwatch_event_rule.monthly_train_rule.name
  target_id = "TrainerLambda"
  arn       = aws_lambda_function.lambda_train.arn
}

# 10. Grant EventBridge Permission to Invoke the Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_train.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.monthly_train_rule.arn
}