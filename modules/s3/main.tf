provider "archive" {
  version = "~> 1.2"
}

provider "aws" {
  version = "~> 2.22"
  region  = var.region
}
