variable "function_name" {
  type        = string
  description = "Name of the function that you'll be deploying"
}

variable "function_prefix" {
  type        = string
  description = "Identifier for function used to prefix resource names"
}

variable "aws_account_number" {
  type        = number
  description = "The AWS account number for the account to build resources in"
}

variable "region" {
  type        = string
  description = "The AWS Region to create the lambda function in"
  default     = "eu-west-1"
}

variable "platform" {
  type        = string
  description = "Platform identifier."
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "environment_image" {
  type        = string
  description = "Which Docker image to use as your build environment"
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
}

variable "environment_variables" {
  description = "A list of all the environment variables to be passed as key/value pairs"
  type        = list(object({
    name      = string
    value     = string
  }))
}

variable "base_os_image" {
  type        = string
  description = "Which base OS to run Docker on"
  default     = "LINUX_CONTAINER"
}

variable "github_base_url" {
  type        = string
  description = "The base url for GitHub"
  default     = "https://github.com/"
}

variable "github_auth_token" {
  type        = string
  description = "The authentication token for github"
}

variable "github_organization" {
  type        = string
  description = "You GitHub organisation"
}

variable "github_repo" {
  type        = string
  description = "The GitHub repo to source the codebase for you function from"
}

variable "github_branch" {
  type        = string
  description = "The branch of the repo that should trigger the webhook"
  default     = "master"
}

variable "webhook_secret" {
  type        = string
  description = "The secret for the GitHub webhook"
}

variable "webhook_ip_range" {
  type        = string
  description = "A list of IPs allowed to trigger the webhook"
  default     = ""
}

variable "use_api_auth" {
  type        = bool
  description = "Whether to add authentication to API gateway with Secrets Manager"
  default     = false
}

variable "api_auth_token" {
  type        = string
  description = "The value of the API authentication key"
  default     = ""
}
