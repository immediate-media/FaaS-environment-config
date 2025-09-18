variable "function_name" {
  description = "Name of the function that you'll be deploying"
}

variable "function_prefix" {
  description = "Identifier for function used to prefix resource names"
}

variable "region" {
  description = "The AWS Region to create the lambda function in"
}

variable "environment" {
  description = "Environment name"
}

variable "use_codepipeline_bucket" {
  description = "Whether or not you require the codepipeline bucket numerous times - if you just require another codebuild cache bucket - specifiy false"
}

variable "mandatory_tags" {
  description = "Standard tags applied to all resources"
  type        = map(string)
  default     = null
}