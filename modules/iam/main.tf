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
  name   = "${var.function_prefix}-${var.environment}-codebuild-serverless-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = file("${path.module}/serverless-role-policy-template.json")
}

resource "aws_iam_role_policy" "remote_codebuild_policy_2" {
  provider = aws.remote_account
  name   = "${var.function_prefix}-${var.environment}-remote-codebuild-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = templatefile("${path.module}/codebuild-cross-account-template.json", {
    remote_account   = var.remote_account_id
    remote_account_role = "${var.function_prefix}-${var.environment}-remote-codebuild-role"
    })
}
