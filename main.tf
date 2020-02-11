provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

module "lambda" {
  source = "./modules/lambda"
}
