output "s3_bucket_name" {
  value = aws_s3_bucket.function_lambda_packages.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.function_lambda_packages.arn
}

output "s3_dummy_package" {
  value = aws_s3_bucket_object.temp_object.id
}
