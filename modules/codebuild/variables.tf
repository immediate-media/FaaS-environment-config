variable "function_name" {
  description = "Name of the function that you'll be deploying"
}

variable "function_prefix" {
  description = "Identifier for function used to prefix resource names"
}

variable "aws_account_number" {
  description = "The AWS account number for the account to build resources in"
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

variable "environment_image" {
  description = "Which Docker image to use as your build environment"
}

variable "environment_variables" {
  description = "A list of all the environment variables to be passed as key/value pairs"
  type        = list(object({
    name      = string
    value     = string
  }))
}

variable "base_os_image" {
  description = "Which base OS to run Docker on"
}

variable "use_api_auth" {
  description = "Whether to add authentication to API gateway with Secrets Manager"
}

variable "kms_key_arn" {
  description = "The key used for decrypting secrets from secrets manager"
}
