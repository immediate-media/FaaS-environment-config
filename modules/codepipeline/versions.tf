terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.57.0"
      
    }
    github = {
      source = "integrations/github"
      version = "~> 6.2.2"
    }
  }
}
