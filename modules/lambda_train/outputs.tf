output "lambda_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.lambda_train.function_name
}

output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.lambda_train.arn
}

output "lambda_role_arn" {
  description = "ARN of the IAM role associated with the Lambda"
  value       = aws_iam_role.lambda_role.arn
}

output "event_rule_name" {
  description = "EventBridge rule name for scheduled invocation"
  value       = aws_cloudwatch_event_rule.monthly_train_rule.name
}