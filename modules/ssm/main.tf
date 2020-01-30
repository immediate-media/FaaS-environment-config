provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

provider "random" {
  version = "~> 2.2.0"
}

locals {
  api_auth_token = "${var.api_auth_token != "" ? var.api_auth_token : random_password.api_auth_token.result}"
}

resource "random_password" "api_auth_token" {
  length           = 64
  min_upper        = 10
  min_lower        = 16
  min_numeric      = 13
  min_special      = 19
  override_special = "!&#$^<>"
}

resource "aws_kms_key" "kms_key" {
  description = var.function_name

  tags = {
    Name        = "${var.function_name} ${var.environment} API Key"
    Platform    = var.platform
    Environment = var.environment
  }
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${var.function_prefix}-${var.environment}"
  target_key_id = aws_kms_key.kms_key.key_id
}

resource "aws_ssm_parameter" "ssm_ps_prod" {
  name   = "${var.function_prefix}-${var.environment}-rest-api-key"
  type   = "SecureString"
  key_id = aws_kms_key.kms_key.arn
  value  = local.api_auth_token

  tags = {
    Name        = "${var.function_name} ${var.environment} API Key"
    Platform    = var.platform
    Environment = var.environment
  }
}
