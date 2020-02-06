variable "function_prefix" {
  description = "Identifier for function used to prefix resource names"
}

variable "aws_account_number" {
  description = "The AWS account number for the account to build resources in"
}

variable "region" {
  description = "The AWS Region to create the lambda function in"
}

variable "environment" {
  description = "Environment name"
}
