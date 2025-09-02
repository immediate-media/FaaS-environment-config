resource "aws_s3_bucket" "function_codepipeline_source_packages" {
  bucket = "${var.function_prefix}-${var.environment}-codepipeline-source-packages"

  tags = merge(local.mandatory_tags,
    { Name = "${var.function_name} ${var.environment} CodePipeline source packages" }
  )
}

resource "aws_s3_bucket" "function_codebuild_cache" {
  bucket = "${var.function_prefix}-${var.environment}-codebuild-cache"

  tags = merge(local.mandatory_tags,
    { Name = "${var.function_name} ${var.environment} CodeBuild cache" }
  )
}
