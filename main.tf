provider "aws" {
  region = var.region
}
##########
### S3 ###
##########

module "s3" {
  source                  = "./modules/s3"
  function_name           = var.function_name
  function_prefix         = var.function_prefix
  region                  = var.region
  platform                = var.platform
  environment             = var.environment
  use_codepipeline_bucket = var.use_codepipeline_bucket
}

#################
### CodeBuild ###
#################
/*
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
  buildspec_name               = var.buildspec_name

  kms_key_arn                  = module.ssm.kms_key_arn
}
*/
module "codebuild" {
  source              = "./modules/codebuild"
  function_name       = var.function_name
  function_prefix     = var.function_prefix
  aws_account_number  = var.aws_account_number
  remote_account_id   = var.remote_account_id
  remote_account_role = var.remote_account_role
  region              = var.region
  platform            = var.platform
  environment         = var.environment

  environment_image     = var.environment_image
  base_os_image         = var.base_os_image
  environment_variables = var.environment_variables
  use_api_auth          = var.use_api_auth
  use_cross_account     = var.use_cross_account
  buildspec_name        = var.buildspec_name

  kms_key_arn = module.ssm.kms_key_arn
}

####################
### CodePipeline ###
####################

module "codepipeline" {
  source          = "./modules/codepipeline"
  function_name   = var.function_name
  function_prefix = var.function_prefix
  region          = var.region
  platform        = var.platform
  environment     = var.environment

  github_base_url     = var.github_base_url
  github_auth_token   = var.github_auth_token
  github_organization = var.github_organization
  github_repo         = var.github_repo
  github_branch       = var.github_branch
  webhook_ip_range    = var.webhook_ip_range
  webhook_secret      = var.webhook_secret

  s3_source_bucket_id  = module.s3.s3_source_bucket_id
  s3_source_bucket_arn = module.s3.s3_source_bucket_arn
}

module "codepipeline_ms" {
  source          = "./modules/codepipeline_multi_stage"
  function_name   = var.function_name
  function_prefix = var.function_prefix
  region          = var.region
  platform        = var.platform
  environment_1   = var.environment_1
  environment_2   = var.environment_2
  environment_3   = var.environment_3

  github_base_url     = var.github_base_url
  github_auth_token   = var.github_auth_token
  github_organization = var.github_organization
  github_repo         = var.github_repo
  github_branch       = var.github_branch
  webhook_ip_range    = var.webhook_ip_range
  webhook_secret      = var.webhook_secret

  component_name_1 = var.component_name_1
  component_name_2 = var.component_name_2
  component_name_3 = var.component_name_3
  codestar_connection_arn = "arn:aws:codestar-connections:eu-west-1:566618458053:connection/634da98b-f8b4-46c9-92d6-3f16f0ebf24a"
}

###########
### SSM ###
###########

module "ssm" {
  source          = "./modules/ssm"
  function_name   = var.function_name
  function_prefix = var.function_prefix
  region          = var.region
  platform        = var.platform
  environment     = var.environment

  use_api_auth   = var.use_api_auth
  api_auth_token = var.api_auth_token
}

###########
### IAM ###
###########

module "iam" {
  source             = "./modules/iam"
  function_prefix    = var.function_prefix
  region             = var.region
  environment        = var.environment
  aws_account_number = var.aws_account_number
  kms_key_arn        = module.ssm.kms_key_arn
  use_api_auth       = var.use_api_auth
  remote_account_id  = var.remote_account_id
}
