output "api_gateway_invoke_url" {
  value = module.api_gateway.invoke_url
}

output "api_gateway_execution_arn" {
  value = module.api_gateway.execution_arn
}

output "api_gateway_cloudwatch_logs" {
  value = module.api_gateway.log_arn
}

output "api_gateway_cloudwatch_logs_role" {
  value = module.api_gateway.api_gateway_cloudwatch_logs_role
}

output "api_gateway_cloudwatch_logs_policy" {
  value = module.api_gateway.api_gateway_logging_policy
}

output "api_gateway_throttle_settings" {
  value = module.api_gateway.throttle_settings
}

output "lambda_invoke_uri" {
  value = module.lambda.lambda_invoke_uri
}

output "lambda_arn" {
  value = module.lambda.lambda_arn
}
