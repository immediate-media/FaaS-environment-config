provider "aws" {
  region  = var.region
}

##########
### S3 ###
##########

module "s3" {
  source                       = "./modules/s3"
  function_name                = var.function_name
  function_prefix              = var.function_prefix
  region                       = var.region
  platform                     = var.platform
  environment                  = var.environment
}

#################
### CodeBuild ###
#################

module "codebuild" {
  source                       = "./modules/codebuild"
  function_name                = var.function_name
  function_prefix              = var.function_prefix
  aws_account_number           = var.aws_account_number
  region                       = var.region
  platform                     = var.platform
  environment                  = var.environment

  environment_image            = var.environment_image
  base_os_image                = var.base_os_image
  environment_variables        = var.environment_variables
  use_api_auth                 = var.use_api_auth

  kms_key_arn                  = module.ssm.kms_key_arn
}

####################
### CodePipeline ###
####################

module "codepipeline" {
  source                       = "./modules/codepipeline"
  function_name                = var.function_name
  function_prefix              = var.function_prefix
  region                       = var.region
  platform                     = var.platform
  environment                  = var.environment

  github_base_url              = var.github_base_url
  github_auth_token            = var.github_auth_token
  github_organization          = var.github_organization
  github_repo                  = var.github_repo
  github_branch                = var.github_branch
  webhook_ip_range             = var.webhook_ip_range
  webhook_secret               = var.webhook_secret

  s3_source_bucket_id          = module.s3.s3_source_bucket_id
  s3_source_bucket_arn         = module.s3.s3_source_bucket_arn
}

###########
### SSM ###
###########

module "ssm" {
  source                       = "./modules/ssm"
  function_name                = var.function_name
  function_prefix              = var.function_prefix
  region                       = var.region
  platform                     = var.platform
  environment                  = var.environment

  use_api_auth                 = var.use_api_auth
  api_auth_token               = var.api_auth_token
}
