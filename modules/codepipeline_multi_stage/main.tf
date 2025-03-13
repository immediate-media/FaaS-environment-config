locals {
  source_config = {
    CodeStarSourceConnection = {
      ConnectionArn        = var.codestar_connection_arn
      FullRepositoryId     = "${var.github_organization}/${var.github_repo}"
      BranchName           = var.github_branch
      # OutputArtifactFormat = "CODEBUILD_CLONE_REF"
    },
    S3 = {
      S3Bucket    = var.s3_bucket
      S3ObjectKey = var.s3_object_key
    # },
    # github_immediate_media = {
    #   ConnectionArn    = var.codestar_connection_arn
    #   FullRepositoryId = "${var.github_organization}/${var.github_repo}"
    #   BranchName       = var.github_branch
    }
  }
}

provider "github" {
  token = var.github_auth_token
  owner = var.github_organization
}

# IAM Role
resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.function_prefix}-codepipeline-role"
  assume_role_policy = file("${path.module}/codepipeline-role-policy-template.json")
}

resource "aws_iam_role_policy" "pipeline_policy" {
  name = "${var.function_prefix}-pipeline-policy"
  role = aws_iam_role.codepipeline_role.id
  policy = templatefile("${path.module}/codepipeline-policy-template.json", {
    s3_source_bucket_arn = aws_s3_bucket.function_codepipeline_source_packages.arn
  })
}

# # CodePipeline Webhook
# resource "aws_codepipeline_webhook" "codepipeline_webhook" {
#   name            = "${var.function_prefix}-codepipeline-webhook"
#   authentication  = "GITHUB_HMAC"
#   target_action   = "Source"
#   target_pipeline = aws_codepipeline.codepipeline_project.name


#   lifecycle {
#     ignore_changes = [
#       authentication_configuration
#     ]
#   }

#   authentication_configuration {
#     secret_token     = var.webhook_secret
#     allowed_ip_range = var.webhook_ip_range
#   }

#   filter {
#     json_path    = "$.ref"
#     match_equals = "refs/heads/${var.github_branch}"
#   }
# }

# # GitHub Webhook
# resource "github_repository_webhook" "github_webhook" {
#   repository = var.github_repo

#   configuration {
#     url          = aws_codepipeline_webhook.codepipeline_webhook.url
#     content_type = "json"
#     insecure_ssl = true
#     secret = var.webhook_secret
#   }

#   events = ["push"]
# }

# CodePipeline Source Bucket
resource "aws_s3_bucket" "function_codepipeline_source_packages" {
  bucket = "${var.function_prefix}-codepipeline-source-packages"

  tags = {
    Name     = "${var.function_name} CodePipeline source packages"
    Platform = var.platform
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "function_codepipeline_source_packages" {
  bucket = aws_s3_bucket.function_codepipeline_source_packages.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = ""
      sse_algorithm     = "AES256"
    }
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
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = lookup(local.source_config, var.source_provider)

    }
  }

  dynamic "stage" {
    for_each = var.disable_test ? [] : [1]
    # Run Tests
    content {
      name = "Test"
      action {
        name            = "Test"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["source_output"]
        version         = "1"

        configuration = {
          ProjectName   = "${var.function_prefix}-${var.component_name_1}-codebuild-project"
          PrimarySource = "source_output"
        }
      }
    }
  }

  # Build environment & Deploy Staging
  dynamic "stage" {
    for_each = var.disable_staging ? [] : [1]

    content {
      # Build environment & Deploy Staging
      name = "Build-Deploy-Staging"

      action {
        name            = "Build-Deploy-Staging"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["source_output"]
        version         = "1"

        configuration = {
          ProjectName   = "${var.function_prefix}-${var.environment_1}-codebuild-project"
          PrimarySource = "source_output"
        }
      }
    }
  }

  dynamic "stage" {
    for_each = var.disable_integration_test ? [] : [1]
    # Integration Tests
    content {
      name = "Integration-Tests"
      action {
        name            = "Integration-Tests"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["source_output"]
        version         = "1"

        configuration = {
          ProjectName   = "${var.function_prefix}-${var.component_name_2}-codebuild-project"
          PrimarySource = "source_output"
        }
      }
    }
  }


  # Build environment & Deploy Pre Prod
  dynamic "stage" {
    for_each = var.disable_preproduction ? [] : [1]
    content {
      name = "Build-Deploy-PreProd"
      action {
        name            = "Build-Deploy-PreProduction"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["source_output"]
        version         = "1"

        configuration = {
          ProjectName   = "${var.function_prefix}-${var.environment_2}-codebuild-project"
          PrimarySource = "source_output"
        }
      }
    }
  }

  # Integration Tests II
  dynamic "stage" {
    for_each = var.disable_integration_II_test ? [] : [1]
    content {
      name = "Integration-Tests-II"
      action {
        name            = "Integration-Tests-II"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["source_output"]
        version         = "1"

        configuration = {
          ProjectName   = "${var.function_prefix}-${var.component_name_3}-codebuild-project"
          PrimarySource = "source_output"
        }
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
      name            = "Build-Deploy-Production"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      run_order       = 2
      version         = "1"

      configuration = {
        ProjectName   = "${var.function_prefix}-${var.environment_3}-codebuild-project"
        PrimarySource = "source_output"
      }
    }
  }
}