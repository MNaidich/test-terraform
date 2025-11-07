output "predictor_lambda_name" {
  description = "Name of the forecasting predictor Lambda function."
  value       = aws_lambda_function.forecasting_predictor.function_name
}

output "predictor_lambda_arn" {
  description = "ARN of the forecasting predictor Lambda function."
  value       = aws_lambda_function.forecasting_predictor.arn
}

output "predictor_iam_role_arn" {
  description = "IAM role ARN used by the forecasting predictor Lambda."
  value       = aws_iam_role.lambda_predictor_role.arn
}
