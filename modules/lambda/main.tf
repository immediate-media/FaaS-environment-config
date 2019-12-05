provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

resource "aws_lambda_function" "function_lambda" {
  function_name    = "${var.function_prefix}-${var.environment}-lambda"
  s3_bucket        = var.s3_bucket_name
  s3_key           = var.lambda_package
  memory_size      = var.lambda_memory
  timeout          = var.lambda_timeout
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  role             = aws_iam_role.function_lambda_role.arn

  vpc_config {
    subnet_ids         = var.lambda_vpc_subnets
    security_group_ids = var.lambda_security_groups
  }

  environment {
    variables = var.lambda_environment_variables
  }
}

resource "aws_lambda_permission" "function_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.source_arn

  depends_on = [
    aws_lambda_function.function_lambda
  ]
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "function_lambda_role" {
  name               = "${var.function_prefix}-${var.environment}-lambda-policy"
  assume_role_policy = file("${path.module}/lambda-policy-template.json")
}

# CloudWatch logging
resource "aws_cloudwatch_log_group" "function_lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.function_lambda.function_name}"
  retention_in_days = var.log_retention

  tags = {
    Name        = var.function_name
    Platform    = var.platform
    Environment = var.environment
  }

  depends_on = [
    aws_lambda_function.function_lambda
  ]
}

resource "aws_iam_policy" "function_lambda_log_policy" {
  name        = "${var.function_prefix}-${var.environment}-lambda-log-policy"
  path        = "/"
  description = "IAM policy for logging function requests"
  policy      = file("${path.module}/lambda-log-policy-template.json")
}

resource "aws_iam_role_policy_attachment" "function_lambda_log_attachment" {
  role       = aws_iam_role.function_lambda_role.name
  policy_arn = aws_iam_policy.function_lambda_log_policy.arn

  depends_on = [
    aws_iam_role.function_lambda_role,
    aws_iam_policy.function_lambda_log_policy
  ]
}

resource "aws_iam_role_policy_attachment" "function_lambda_vpc_attachment" {
  count      = length(var.lambda_vpc_subnets) > 0 ? 1 : 0

  role       = aws_iam_role.function_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/function-role/AWSLambdaVPCAccessExecutionRole"

  depends_on = [
    aws_iam_role.function_lambda_role
  ]
}


