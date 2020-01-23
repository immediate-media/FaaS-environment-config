variable "function_name" {
  type        = string
  description = "Name of the function that you'll be deploying"
}

variable "function_prefix" {
  type        = string
  description = "Identifier for function used to prefix resource names"
}

variable "platform" {
  type        = string
  description = "Platform identifier."
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "region" {
  type        = string
  description = "The AWS Region to create the lambda function in"
  default     = "eu-west-1"
}

variable "lambda_runtime" {
  type        = string
  description = "Version of nodejs to use when running tachyon"
  default     = "nodejs10.x"
}

variable "lambda_package" {
  type        = string
  description = "Name of the zip file you wish to deploy with path"
  default     = ""
}

variable "lambda_handler" {
  type        = string
  description = "The handler to access the Lambda function with"
  default     = "lambda.handler"
}

variable "lambda_memory" {
  type        = number
  description = "The amount of memory to give the Lambda function"
  default     = 512
}

variable "lambda_timeout" {
  type        = number
  description = "The amount of time your Lambda Function has to run in seconds"
  default     = 10
}

variable "lambda_vpc_subnets" {
  type        = list
  description = "A list of subnet IDs associated with the Lambda function"
  default     = []
}

variable "lambda_security_groups" {
  type        = list
  description = "A list of security group IDs associated with the Lambda function"
  default     = []
}

variable "lambda_environment_variables" {
  type        = map(any)
  description = "A map of all the environment variables to be passed to your Lambda function"
  default     = {}
}

variable "api_gateway_endpoint_configuration" {
  type        = list
  description = "A list of endpoint types. This resource currently only supports managing a single value. Valid values: EDGE, REGIONAL or PRIVATE."
  default     = ["EDGE"]
}

variable "api_gateway_api_key_source" {
  type        = string
  description = "The source of the API key for requests."
  default     = "HEADER"
}

variable "api_gateway_minimum_compression_size" {
  type        = number
  description = "Minimum response size to compress for the REST API. Integer between -1 and 10485760."
  default     = -1
}

variable "api_gateway_binary_media_types" {
  type        = list
  description = "The list of binary media types supported by the RestApi."
  default     = []
}

variable "api_gateway_content_handling" {
  type        = string
  description = "Specifies how to handle request payload content type conversions."
  default     = ""
}

variable "log_retention" {
  type        = number
  description = "The number of days to retain logs for in cloudwatch"
  default     = 7
}