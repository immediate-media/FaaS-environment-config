terraform {
  required_version = ">= 0.13"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 2.2"
    }
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [aws]
    }
  }
}
