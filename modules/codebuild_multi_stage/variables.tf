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

variable "buildspec_name" {
  description = "The Buildspec file name - usually buildspec.yml"
}

variable "assume_role_policy" {
  description = "Allows you to choose the standard codebuild assume role policy, or the remote assume role policy - use codebuild-role-template for standard and cross-account-template for remote"
}

variable "remote_account_id" {
  type        = number
  description = "The AWS account number for the remote account to build resources in"
}

variable "remote_account_role" {
  type        = string
  description = "The role to use in the remote account"
}
