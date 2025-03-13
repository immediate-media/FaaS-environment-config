resource "aws_s3_bucket" "function_codepipeline_source_packages" {
  bucket = "${var.function_prefix}-${var.environment}-codepipeline-source-packages"

  tags = {
    Name     = "${var.function_name} ${var.environment} CodePipeline source packages"
    Platform = var.platform
    Env      = var.environment
    Service  = var.function_name
  }
}

resource "aws_s3_bucket_acl" "function_codepipeline_source_packages" {
  bucket = aws_s3_bucket.function_codepipeline_source_packages.bucket
  acl    = "private"
}

resource "aws_s3_bucket" "function_codebuild_cache" {
  bucket = "${var.function_prefix}-${var.environment}-codebuild-cache"

  tags = {
    Name     = "${var.function_name} ${var.environment} CodeBuild cache"
    Platform = var.platform
    Env      = var.environment
    Service  = var.function_name
  }
}

resource "aws_s3_bucket_acl" "function_codebuild_cache" {
  bucket = aws_s3_bucket.function_codebuild_cache.bucket
  acl    = "private"
}