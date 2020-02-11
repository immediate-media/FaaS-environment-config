provider "aws" {
  alias = "test"
  version = "~> 2.22"
  region  = var.region
}

module "s3" {
  source = "./modules/s3"
  providers {
    aws = "aws.test"
  }  
}
