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

variable "github_base_url" {
  description = "The base url for GitHub"
}

variable "github_auth_token" {
  description = "The authentication token for github"
}

variable "github_organization" {
  description = "You GitHub organisation"
}

variable "github_repo" {
  description = "The GitHub repo to source the codebase for you function from"
}

variable "github_branch" {
  description = "The branch of the repo that should trigger the webhook"
}

variable "webhook_secret" {
  description = "The secret for the GitHub webhook"
}

variable "webhook_ip_range" {
  description = "A list of IPs allowed to trigger the webhook"
}
