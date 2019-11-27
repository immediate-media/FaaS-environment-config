output "invoke_url" {
  value = aws_api_gateway_deployment.function_deployment.invoke_url
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.function_api.execution_arn
}

output "log_arn" {
  value = aws_iam_policy.api_gateway_logging.arn
}

output "api_gateway_cloudwatch_logs_role" {
  value = aws_iam_role.api_gateway_cloudwatch_logs.arn
}

output "api_gateway_logging_policy" {
  value = aws_iam_policy.api_gateway_logging
}

output "throttle_settings" {
  value = aws_api_gateway_account.function_account_settings
}
