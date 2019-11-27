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

variable "lambda_invoke_uri" {
  description = "The lambda URI that API GAteway should invoke"
}
