provider "aws" {
  region = var.region
}

provider "github" {
  token = var.github_auth_token
  owner = "immediate-media"
}

data "aws_codestarconnections_connection" "github_connection" {
  arn = aws_codestarconnections_connection.github_connection.arn
}

# IAM Role
resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.function_prefix}-${var.environment}-codepipeline-role"
  assume_role_policy = file("${path.module}/codepipeline-role-policy-template.json")
}

resource "aws_iam_role_policy" "pipeline_policy" {
  name = "${var.function_prefix}-${var.environment}-pipeline-policy"
  role = aws_iam_role.codepipeline_role.id
  policy = templatefile("${path.module}/codepipeline-policy-template.json", {
    s3_source_bucket_arn = var.s3_source_bucket_arn
  })
}

# CodePipeline Webhook
resource "aws_codepipeline_webhook" "codepipeline_webhook" {
  name            = "${var.function_prefix}-${var.environment}-codepipeline-webhook"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.codepipeline_project.name


  lifecycle {
    ignore_changes = [
      authentication_configuration
    ]
  }

  authentication_configuration {
    secret_token     = var.webhook_secret
    allowed_ip_range = var.webhook_ip_range
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/${var.github_branch}"
  }
}

# GitHub Webhook
resource "github_repository_webhook" "github_webhook" {
  repository = var.github_repo

  configuration {
    url          = aws_codepipeline_webhook.codepipeline_webhook.url
    content_type = "form"
    insecure_ssl = true
    secret       = var.webhook_secret
  }

  events = ["push"]
}

# CodePipeline Project
resource "aws_codepipeline" "codepipeline_project" {
  name     = "${var.function_prefix}-${var.environment}-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  # Store codepipeline artifacts in the custom S3 bucket
  artifact_store {
    location = var.s3_source_bucket_id
    type     = "S3"
  }

  # Source environment
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = "immediate-media"
        Repo       = var.github_repo
        Branch     = var.github_branch
        OAuthToken = var.github_auth_token
        ConnectionArn = data.aws_codestarconnections_connection.github_connection.arn
      }
    }
  }

  # Build environment
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName   = "${var.function_prefix}-${var.environment}-codebuild-project"
        PrimarySource = "source_output"
      }
    }
  }
}
