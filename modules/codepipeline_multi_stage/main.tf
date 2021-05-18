provider "github" {
  token        = var.github_auth_token
  organization = "immediate-media"
}

# IAM Role
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.function_prefix}-codepipeline-role"
  assume_role_policy = file("${path.module}/codepipeline-role-policy-template.json")
}

resource "aws_iam_role_policy" "pipeline_policy" {
  name = "${var.function_prefix}-pipeline-policy"
  role = aws_iam_role.codepipeline_role.id
  policy = templatefile("${path.module}/codepipeline-policy-template.json", {
      s3_source_bucket_arn = aws_s3_bucket.function_codepipeline_source_packages.arn
  })
}

# CodePipeline Webhook
resource "aws_codepipeline_webhook" "codepipeline_webhook" {
  count           = var.source_provider == "GitHub" ? 1 : 0
  name            = "${var.function_prefix}-codepipeline-webhook"
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
  count      = var.source_provider == "GitHub" ? 1 : 0
  repository = var.github_repo

  configuration {
    url          = aws_codepipeline_webhook.codepipeline_webhook.url
    content_type = "form"
    insecure_ssl = true
    secret       = var.webhook_secret
  }

  events = ["push"]
}

# CodePipeline Source Bucket
resource "aws_s3_bucket" "function_codepipeline_source_packages" {
  bucket = "${var.function_prefix}-codepipeline-source-packages"
  acl    = "private"

  tags = {
    Name        = "${var.function_name} CodePipeline source packages"
    Platform    = var.platform
  }
}

# CodePipeline Project
resource "aws_codepipeline" "codepipeline_project" {
  name     = "${var.function_prefix}-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  # Store codepipeline artifacts in the custom S3 bucket
  artifact_store {
    location = aws_s3_bucket.function_codepipeline_source_packages.id
    type     = "S3"
  }

  # Source environment
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = var.source_owner
      provider         = var.source_provider
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = var.source_provider == "GitHub" ? {
        Owner      = "immediate-media"
        Repo       = var.github_repo
        Branch     = var.github_branch
        OAuthToken = var.github_auth_token
      } : {
        S3Bucket    = var.source_s3_bucket
        S3ObjectKey = var.source_s3_object_key
      }
    }
  }

  # Run tests
  stage {
    name = "Test"

    action {
      name             = "Test"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      version          = "1"

      configuration = {
        ProjectName   = "${var.function_prefix}-${var.component_name_1}-codebuild-project"
        PrimarySource = "source_output"
      }
    }
  }

  # Build environment & Deploy Staging
  stage {
    name = "Build-Deploy-Staging"

    action {
      name             = "Build-Deploy-Staging"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      version          = "1"

      configuration = {
        ProjectName   = "${var.function_prefix}-${var.environment_1}-codebuild-project"
        PrimarySource = "source_output"
      }
    }
  }

  # Integration Tests
  stage {
    name = "Integration-Tests"

    action {
      name             = "Integration-Tests"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      version          = "1"

      configuration = {
        ProjectName   = "${var.function_prefix}-${var.component_name_2}-codebuild-project"
        PrimarySource = "source_output"
      }
    }
  }

  # Build environment & Deploy Pre Prod
  stage {
    name = "Build-Deploy-PreProd"

    action {
      name             = "Build-Deploy-PreProduction"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      version          = "1"

      configuration = {
        ProjectName   = "${var.function_prefix}-${var.environment_2}-codebuild-project"
        PrimarySource = "source_output"
      }
    }
  }

  # Integration Tests II
  stage {
    name = "Integration-Tests-II"

    action {
      name             = "Integration-Tests-II"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      version          = "1"

      configuration = {
        ProjectName   = "${var.function_prefix}-${var.component_name_3}-codebuild-project"
        PrimarySource = "source_output"
      }
    }
  }

  # Build environment & Deploy Production - manual approval
  stage {
    name = "Build-Deploy-Production"

    action {
      name      = "Approval-Stage"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      run_order = 1
      version   = "1"
    }

    action {
      name             = "Build-Deploy-Production"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      run_order        = 2
      version          = "1"

      configuration = {
        ProjectName   = "${var.function_prefix}-${var.environment_3}-codebuild-project"
        PrimarySource = "source_output"
      }
    }
  }
}
