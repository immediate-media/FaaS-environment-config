variable "function_name" {
  description = "Name of the function that you'll be deploying"
}

variable "function_prefix" {
  description = "Identifier for function used to prefix resource names"
}

variable "platform" {
  description = "Platform identifier."
}

variable "region" {
  description = "The AWS Region to create the lambda function in"
}

variable "environment" {
  description = "Environment name"
}

variable "s3_bucket_name" {
    description = "Name of the S3 bucket to store the build artifact in"
}

variable "lambda_package" {
  description = "Name of zip file you wish to deploy"
}
