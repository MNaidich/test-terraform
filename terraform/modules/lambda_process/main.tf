# 1. IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-${var.environment}-lambda-process-role"

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
resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 3. Custom Policy for S3 Full Access (restricted to one bucket)
resource "aws_iam_policy" "lambda_s3_policy" {
  name        = "${var.project_name}-${var.environment}-lambda-s3-policy"
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

# 4. Attach the S3 Policy to the Role
resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

# 5. Package the Lambda Function Code
data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = var.lambda_process_path
  output_path = "${path.module}/lambda_package.zip"
}

# 6. Create the Lambda Function
resource "aws_lambda_function" "lambda_process" {
  function_name    = "${var.project_name}-${var.environment}-lambda-process"
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

# 7. Allow S3 to Trigger the Lambda
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_process.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}

# 8. Configure the S3 Bucket Notification
resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = var.s3_bucket_id

  lambda_function {
    events             = ["s3:ObjectCreated:*"]
    filter_prefix      = "input/"
    lambda_function_arn = aws_lambda_function.lambda_process.arn
  }

  depends_on = [
    aws_lambda_permission.allow_s3_invoke
  ]
}