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

variable "use_codepipeline_bucket" {
  description = "Whether or not you require the codepipeline bucket numerous times - if you just require another codebuild cache bucket - specifiy false"
}
