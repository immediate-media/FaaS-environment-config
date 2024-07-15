terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [aws]
    }
    github = {
      source = "integrations/github"
    }
  }
}

provider "aws" {
  region = var.region
}