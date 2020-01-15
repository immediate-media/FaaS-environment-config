provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

##########
### S3 ###
##########

module "s3" {
  source                       = "./modules/s3"
  function_name                = var.function_name
  function_prefix              = var.function_prefix
  platform                     = var.platform
  environment                  = var.environment
  region                       = var.region
  lambda_package               = var.lambda_package
}

##############
### Lambda ###
##############

module "lambda" {
  source                       = "./modules/lambda"
  function_name                = var.function_name
  function_prefix              = var.function_prefix
  platform                     = var.platform
  region                       = var.region
  environment                  = var.environment

  lambda_runtime               = var.lambda_runtime
  lambda_package               = "${var.lambda_package != "" ? var.lambda_package : module.s3.s3_dummy_package}"
  lambda_handler               = var.lambda_handler
  lambda_memory                = var.lambda_memory
  lambda_timeout               = var.lambda_timeout
  lambda_vpc_subnets           = var.lambda_vpc_subnets
  lambda_security_groups       = var.lambda_security_groups
  lambda_environment_variables = var.lambda_environment_variables

  log_retention                = var.log_retention

  s3_bucket_name               = module.s3.s3_bucket_name
  source_arn                   = "${module.api_gateway.execution_arn}/*/*/*"
}

###################
### API Gateway ###
###################

module "api_gateway" {
  source                       = "./modules/api-gateway"
  function_name                = var.function_name
  function_prefix              = var.function_prefix
  platform                     = var.platform
  region                       = var.region
  environment                  = var.environment

  lambda_invoke_uri            = module.lambda.lambda_invoke_uri
  api_gateway_content_handling = var.api_gateway_content_handling
}
