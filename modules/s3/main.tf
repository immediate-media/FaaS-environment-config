provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

resource "aws_s3_bucket" "function_codepipeline_source_packages" {
  bucket = "${var.function_prefix}-${var.environment}-codepipeline-source-packages"
  acl    = "private"

  tags = {
    Name        = "${var.function_name} ${var.environment} CodePipeline source packages"
    Platform    = var.platform
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "function_codebuild_cache" {
  bucket = "${var.function_prefix}-${var.environment}-codebuild-cache"
  acl    = "private"

  tags = {
    Name        = "${var.function_name} ${var.environment} CodeBuild cache"
    Platform    = var.platform
    Environment = var.environment
  }
}
