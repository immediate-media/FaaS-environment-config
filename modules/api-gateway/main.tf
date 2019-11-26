provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

resource "aws_api_gateway_rest_api" "function_api" {
  name        = "${var.function_prefix}-${var.environment}-api"
  description = "API for accessing the Lambda function"
}

resource "aws_api_gateway_resource" "function_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.function_api.id
  parent_id   = aws_api_gateway_rest_api.function_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "function_method" {
  rest_api_id   = aws_api_gateway_rest_api.function_api.id
  resource_id   = aws_api_gateway_resource.function_api_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.function_api.id
  resource_id = aws_api_gateway_resource.function_api_resource.id
  http_method = aws_api_gateway_method.function_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_uri
}

resource "aws_api_gateway_method_response" "ok" {
  rest_api_id = aws_api_gateway_rest_api.function_api.id
  resource_id = aws_api_gateway_resource.function_api_resource.id
  http_method = aws_api_gateway_method.function_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "lambda_response" {
  rest_api_id = aws_api_gateway_rest_api.function_api.id
  resource_id = aws_api_gateway_resource.function_api_resource.id
  http_method = aws_api_gateway_method.function_method.http_method
  status_code = aws_api_gateway_method_response.ok.status_code

  response_templates = {
    "application/json" = ""
  }

  depends_on  = [
    aws_api_gateway_integration.lambda
  ]
}

resource "aws_api_gateway_stage" "deploy_stage" {
  stage_name    = var.environment
  rest_api_id   = aws_api_gateway_rest_api.function_api.id
  deployment_id = aws_api_gateway_deployment.function_deployment.id
}

resource "aws_api_gateway_deployment" "function_deployment" {
  rest_api_id = aws_api_gateway_rest_api.function_api.id
  stage_name  = ""

  depends_on = [
    aws_api_gateway_method.function_method,
    aws_api_gateway_integration.lambda
  ]
}

## API Gateway Logging ##
resource "aws_api_gateway_method_settings" "logging" {
  rest_api_id = aws_api_gateway_rest_api.function_api.id
  stage_name  = aws_api_gateway_stage.deploy_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true

    # Limit the rate of calls to prevent abuse and unwanted charges
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}

## Cloud Watch Logs ##
resource "aws_api_gateway_account" "function_account_settings" {
  cloudwatch_role_arn = "${aws_iam_role.api_gateway_cloudwatch_logs.arn}"
}

resource "aws_iam_role" "api_gateway_cloudwatch_logs" {
  name               = "${var.function_prefix}-${var.environment}-cloudwatch-role"
  assume_role_policy = file("${path.module}/api-gateway-policy-template.json")
}

resource "aws_iam_policy" "api_gateway_logging" {
  name        = "${var.function_prefix}-${var.environment}-cloudwatch-policy"
  path        = "/"
  description = "IAM policy for logging API requests"
  policy      = file("${path.module}/cloudwatch-policy-template.json")
}

resource "aws_iam_role_policy_attachment" "apigateway_logs" {
  role       = aws_iam_role.api_gateway_cloudwatch_logs.name
  policy_arn = aws_iam_policy.api_gateway_logging.arn
}

