variable "function_name" {
  description = "Name of the function that you'll be deploying."
}

variable "function_prefix" {
  description = "Identifier for function used to prefix resource names."
}

variable "platform" {
  description = "Platform identifier."
}

variable "region" {
  description = "The AWS Region to create the lambda function in."
}

variable "environment" {
  description = "Environment name."
}

variable "lambda_invoke_uri" {
  description = "The lambda URI that API GAteway should invoke."
}

variable "api_gateway_endpoint_configuration" {
  description = "A list of endpoint types. This resource currently only supports managing a single value. Valid values: EDGE, REGIONAL or PRIVATE."
}

variable "api_gateway_api_key_source" {
  description = "The source of the API key for requests."
}

variable "api_gateway_minimum_compression_size" {
  description = "Minimum response size to compress for the REST API. Integer between -1 and 10485760."
}

variable "api_gateway_binary_media_types" {
  description = "The list of binary media types supported by the RestApi."
}

variable "api_gateway_content_handling" {
  description = "Specifies how to handle request payload content type conversions."
}
