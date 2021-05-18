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

variable "environment_1" {
  description = "Environment name stage/dev"
}

variable "environment_2" {
  description = "Environment name pre-prod/uat"
}

variable "environment_3" {
  description = "Environment name prod"
}

variable "github_base_url" {
  description = "The base url for GitHub"
  default     = null
}

variable "github_auth_token" {
  description = "The authentication token for github"
  default     = null
}

variable "github_organization" {
  description = "You GitHub organisation"
  default     = null
}

variable "github_repo" {
  description = "The GitHub repo to source the codebase for you function from"
  default     = null
}

variable "github_branch" {
  description = "The branch of the repo that should trigger the webhook"
  default     = null
}

variable "webhook_secret" {
  description = "The secret for the GitHub webhook"
  default     = null
}

variable "webhook_ip_range" {
  description = "A list of IPs allowed to trigger the webhook"
  default     = null
}

variable "component_name_1" {
  description = "A suitable name for additional stage in codepipeline"
}

variable "component_name_2" {
  description = "A suitable name for additional stage in codepipeline"
}

variable "component_name_3" {
  description = "A suitable name for additional stage in codepipeline"
}

variable "source_owner" {
  description = "The creator of the action being called. Possible values are AWS, Custom and ThirdParty."
  default     = "ThirdParty"
}

variable "source_provider" {
  description = "The provider of the service being called by the action. Valid providers are determined by the action category."
  default     = "GitHub"
}

variable "source_s3_bucket" {
  description = "The S3 bucket to use as the source, if any."
  default     = null
}

variable "source_object_key" {
  description = "The S3 objecct key to use as the source, if any."
  default     = null
}
