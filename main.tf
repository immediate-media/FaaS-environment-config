provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

module "faas" {
  source = "git::https://github.com/immediate-media/FaaS-environment-config?ref=tags/1.1.0"
  providers {
    aws = "aws"
  }  
}
