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

variable "component_name_1" {
  description = "A suitable name for additional stage in codepipeline"
}

variable "component_name_2" {
  description = "A suitable name for additional stage in codepipeline"
}

variable "component_name_3" {
  description = "A suitable name for additional stage in codepipeline"
}

variable "codestar_connection_arn" {
  description = "Codestar_connection_arn"
}

variable "disable_staging" {
  description = "Disable staging stage"
  default     = false
}

variable "disable_preproduction" {
  description = "Disable preproduction stage"
  default     = false
}

variable "disable_test" {
  description = "Disable Test Stage"
  default     = true
}

variable "disable_integration_test" {
  description = "Disable Integration Test Stage"
  default     = true
}

variable "disable_integration_II_test" {
  description = "Disable Integration II Test Stage"
  default     = true
}
