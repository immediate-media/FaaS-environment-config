variable "function_name" {
  description = "Name of the function that you'll be deploying"
}

variable "function_prefix" {
  description = "Identifier for function used to prefix resource names"
}

variable "region" {
  description = "The AWS Region to create the lambda function in"
}

variable "platform" {
  description = "Platform identifier."
}

variable "environment" {
  description = "Environment name"
}

variable "use_api_auth" {
  description = "Whether to add authentication to API gateway with Secrets Manager"
}

variable "api_auth_token" {
  description = "The value of the API authentication key"
}