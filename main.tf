provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

##########
### S3 ###
##########

module "s3" {
  source                       = "./modules/s3"
}

##############
### Lambda ###
##############

module "lambda" {
  source                       = "./modules/lambda"
}

###################
### API Gateway ###
###################

module "api_gateway" {
  source                       = "./modules/api-gateway"
}
