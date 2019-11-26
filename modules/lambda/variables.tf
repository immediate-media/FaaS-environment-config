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

variable "lambda_runtime" {
  description = "Version of nodejs to use when running tachyon"
}

variable "lambda_package" {
  description = "Name of zip file you wish to deploy"
}

variable "lambda_handler" {
  description = "The handler to access the Lambda function with" 
}

variable "lambda_memory" {
  description = "The amount of memory to give the Lambda function"
}

variable "lambda_timeout" {
  description = "The amount of time your Lambda Function has to run in seconds"
}

variable "lambda_vpc_subnets" {
  description = "A list of subnet IDs associated with the Lambda function"
}

variable "lambda_security_groups" {
  description = "A list of security group IDs associated with the Lambda function"
}

variable "lambda_environment_variables" {
  description = "An object with KEY = value pairs to set environment variables for your Lambda function"
}

variable "s3_bucket_name" {
  description = "Name of the bucket to get the function source from"
}

variable "source_arn" {
  description = "The ARN of the API Gateway that will trigger the Lambda function"
}

variable "log_retention" {
  description = "The number of days to retain logs for in cloudwatch"
}
