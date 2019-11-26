provider "archive" {
  version = "~> 1.2"
}

provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

data "archive_file" "dummy" {
  type        = "zip"
  output_path = "${path.module}/dummy-function.zip"

  source {
    content  = "Hello World!"
    filename = "dummy.txt"
  }
}

resource "aws_s3_bucket" "function_lambda_packages" {
  bucket = "${var.function_prefix}-${var.environment}-lambda-packages"
  acl    = "private"

  tags = {
    Name     = "${var.function_name} ${var.platform} lambda packages"
    Platform = "${var.platform}"
  }
}

resource "aws_s3_bucket_object" "temp_object" {
  bucket = aws_s3_bucket.function_lambda_packages.id
  key    = "dummy-function.zip"
  source = "${path.module}/dummy-function.zip"
}
