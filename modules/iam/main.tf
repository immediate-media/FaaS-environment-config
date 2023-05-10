# IAM Role
resource "aws_iam_role" "remote_codebuild_role" {
  name = "${var.function_prefix}-${var.environment}-remote-codebuild-role"
  assume_role_policy = templatefile("${path.module}/codebuild-remote-cross-account-template.json", {
    aws_account_number = var.aws_account_number,
    local_account_role = "${var.function_prefix}-${var.environment}-codebuild-role"
  })
}

# IAM polices
resource "aws_iam_role_policy" "remote_codebuild_policy" {
  name   = "${var.function_prefix}-${var.environment}-codebuild-serverless-policy"
  role   = aws_iam_role.remote_codebuild_role.id
  policy = file("${path.module}/serverless-role-policy-template.json")

  depends_on = [
    aws_iam_role.remote_codebuild_role,
  ]
}

resource "aws_iam_role_policy" "remote_codebuild_policy_2" {
  count = var.use_api_auth ? 1 : 0

  name = "${var.function_prefix}-${var.environment}-codebuild-ssm-policy"
  role = aws_iam_role.remote_codebuild_role.id
  policy = templatefile("${path.module}/ssm-role-policy-template.json", {
    aws_account_number = var.remote_account_id,
    region             = var.region,
    environment        = var.environment,
    function_prefix    = var.function_prefix
    kms_key_arn        = var.kms_key_arn
  })
  depends_on = [
    aws_iam_role.remote_codebuild_role,
  ]
}
