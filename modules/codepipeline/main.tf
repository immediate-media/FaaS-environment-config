provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

resource "aws_iam_role" "pipeline_role" {
  name = "${var.function_prefix}-${var.environment}-pipeline-role"
  assume_role_policy = file("${path.module}/codepipeline-role-policy-template.json")
}

resource "aws_iam_role_policy" "pipeline_policy" {
  name = "${var.function_prefix}-${var.environment}-pipeline-policy"
  role = "${aws_iam_role.pipeline_role.id}"
  policy = templatefile("${path.module}/codepipeline-policy-template.json", {
      s3_bucket_arn = var.s3_bucket_arn
  })
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.function_prefix}-${var.environment}-pipeline"
  role_arn = "${aws_iam_role.pipeline_role.arn}"

  artifact_store {
    location = var.s3_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner  = var.github_organisation
        Repo   = var.github_repo
        Branch = var.github_repo_branch
      }
    }
  }

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
        ProjectName = var.function_name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ActionMode     = "REPLACE_ON_FAILURE"
        Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
        OutputFileName = "CreateStackOutput.json"
        StackName      = "MyStack"
        TemplatePath   = "build_output::sam-templated.yaml"
      }
    }
  }
}