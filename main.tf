provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

##############
### Lambda ###
##############

module "lambda" {
  source                       = "./modules/lambda"
  region  = var.region
}
