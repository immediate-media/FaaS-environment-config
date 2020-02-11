provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

module "s3" {
  providers {
    aws = "aws"
  }  
}
