provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

##########
### S3 ###
##########

module "s3" {
  source                       = "./modules/s3"
  region  = var.region
}

##############
### Lambda ###
##############

module "lambda" {
  source                       = "./modules/lambda"
  region  = var.region
}

###################
### API Gateway ###
###################

module "api_gateway" {
  source                       = "./modules/api-gateway"
  region  = var.region
}
