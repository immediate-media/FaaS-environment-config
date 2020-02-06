# IAM Role
resource "aws_iam_role" "codebuild_role" {
  name               = "${var.function_prefix}-${var.environment}-codebuild-role"
  assume_role_policy = file("${path.module}/codebuild-role-template.json")
}

# IAM polices
resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "${var.function_prefix}-${var.environment}-codebuild-base-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = templatefile("${path.module}/codebuild-role-policy-template.json", {
    aws_account_number = var.aws_account_number,
    region             = var.region,
    environment        = var.environment,
    function_prefix    = var.function_prefix
  })
}

resource "aws_iam_role_policy" "codebuild_policy_2" {
  name   = "${var.function_prefix}-${var.environment}-codebuild-serverless-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = file("${path.module}/serverless-role-policy-template.json")
}

resource "aws_iam_role_policy" "codebuild_policy_3" {
  count  = var.use_api_auth ? 1 : 0

  name   = "${var.function_prefix}-${var.environment}-codebuild-ssm-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = templatefile("${path.module}/ssm-role-policy-template.json", {
    aws_account_number = var.aws_account_number,
    region          = var.region,
    environment     = var.environment,
    function_prefix = var.function_prefix
    kms_key_arn     = var.kms_key_arn
  })
}

# CodeBuild Cache Bucket
resource "aws_s3_bucket" "function_codebuild_cache" {
  bucket = "${var.function_prefix}-${var.environment}-codebuild-cache"
  acl    = "private"

  tags = {
    Name        = "${var.function_name} ${var.environment} CodeBuild cache"
    Platform    = var.platform
    Environment = var.environment
  }
}

# CodeBuild Project
resource "aws_codebuild_project" "codebuild_project" {
  name         = "${var.function_prefix}-${var.environment}-codebuild-project"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = "${var.function_prefix}-${var.environment}-codebuild-cache"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = var.environment_image
    type            = var.base_os_image
    privileged_mode = "true"

    # Environment variables for buildspec.yml - passed in as a list
    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
      }
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = var.buildspec_name
  }
}
