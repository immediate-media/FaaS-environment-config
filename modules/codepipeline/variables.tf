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

variable "s3_source_bucket_id" {
  description = "Name of the S3 bucket to source the build artifact from"
}

variable "s3_source_bucket_arn" {
  description = "The ARN of the S3 bucket to source the build artifact from"
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

variable "codestar_ghec_connection_arn" {
  description = "GitHub Enterprise Cloud connection arn to trigger codepipeline"
  default     = null
}

variable "codestar_connection_arn" {
  description = "GitHub connection arn to trigger codepipeline"
  default     = null
}

variable "github_public_repo" {
  description = "Public Git repo to look for source code"
  type        = string
  default     = ""
}

variable "github_public_branch" {
  description = "Public Git branch to look for changes and clone"
  type        = string
  default     = "main"
}

variable "s3_bucket" {
  description = "S3 bucket where to store assets"
}

variable "s3_object_key" {
  description = "filename of the target zip file for codepipeline."
  default     = ""
}

variable "source_provider" {
  description = "The provider of the service being called by the action. Valid providers are determined by the action category."
  type        = string
  default     = "S3"
}