output "s3_source_bucket_id" {
  value = aws_s3_bucket.function_codepipeline_source_packages.id
}

output "s3_source_bucket_arn" {
  value = aws_s3_bucket.function_codepipeline_source_packages.arn
}

output "s3_cache_bucket_id" {
  value = aws_s3_bucket.function_codebuild_cache.id
}

output "s3_cache_bucket_arn" {
  value = aws_s3_bucket.function_codebuild_cache.arn
}
