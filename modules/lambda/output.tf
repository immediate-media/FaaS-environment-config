output "lambda_invoke_uri" {
  value = aws_lambda_function.function_lambda.invoke_arn
}

output "lambda_arn" {
  value = aws_lambda_function.function_lambda.arn
}
