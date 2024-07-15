terraform {
  required_version = ">= 1.9.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.2"
    }
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [aws]
    }
  }
}

provider "aws" {
  region = var.region
}