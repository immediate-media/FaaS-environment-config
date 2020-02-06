# IAM Role
resource "aws_iam_role" "remote_codebuild_role" {
  provider = aws.remote_account
  name               = "${var.function_prefix}-${var.environment}-remote-codebuild-role"
  assume_role_policy = templatefile("${path.module}/codebuild-remote-cross-account-template.json", {
    aws_account_number = var.aws_account_number,
    local_account_role = "${var.function_prefix}-${var.environment}-codebuild-role"
    })
}

# IAM polices
resource "aws_iam_role_policy" "remote_codebuild_policy" {
  provider = aws.remote_account
  name   = "${var.function_prefix}-${var.environment}-codebuild-serverless-policy"
  role   = "${var.function_prefix}-${var.environment}-remote-codebuild-role"
  policy = file("${path.module}/serverless-role-policy-template.json")

  depends_on = [
  aws_iam_role.remote_codebuild_role,
  ]
}
