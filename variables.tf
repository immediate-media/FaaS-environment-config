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

variable "remote_account_id" {
  type        = number
  description = "The AWS account number for the remote account to build resources in"
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

variable "remote_account_access_key" {
  type        = string
  description = "The access key used to access a remote account"
}

variable "remote_account_secret_key" {
  type        = string
  description = "The secret key used to access a remote account"
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

variable "buildspec_name" {
  type        = string
  description = "The Buildspec file name - usually buildspec.yml"
  default     = "buildspec.yml"
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

variable "use_cross_account" {
  type        = bool
  description = "Whether to use the cross account assume role policy for codebuild"
  default     = false
}

variable "create_remote_role" {
  type        = bool
  description = "Whether to create the cross account role in the target account"
  default     = false
}

variable "remote_account_role" {
  type        = string
  description = "The role to use in the remote account"
}


variable "api_auth_token" {
  type        = string
  description = "The value of the API authentication key"
  default     = ""
}

variable "use_codepipeline_bucket" {
  type        = bool
  description = "Whether or not you require the codepipeline bucket numerous times - if you just require another codebuild cache bucket - specifiy false"
  default     = true
}

variable "component_name_1" {
  type        = string
  description = "A suitable name for additional stage in codepipeline"
}

variable "component_name_2" {
  type        = string
  description = "A suitable name for additional stage in codepipeline"
}

variable "component_name_3" {
  type        = string
  description = "A suitable name for additional stage in codepipeline"
}

variable "environment_1" {
  type        = string
  description = "Environment name stage/dev"
}

variable "environment_2" {
  type        = string
  description = "Environment name pre-prod/uat"
}

variable "environment_3" {
  type        = string
  description = "Environment name prod"
}

variable "assume_role_policy" {
  description = "Allows you to choose the standard codebuild assume role policy, or the remote assume role policy - use codebuild-role-template for standard and cross-account-template for remote"
}
