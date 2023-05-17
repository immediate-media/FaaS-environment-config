terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.22"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 2.2.0"
    }
  }
}
