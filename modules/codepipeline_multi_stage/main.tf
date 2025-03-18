provider "github" {
  token = var.github_auth_token
  owner = "immediate-media"
}

# CodePipeline Webhook
resource "aws_codepipeline_webhook" "codepipeline_webhook" {
  name            = "${var.function_prefix}-codepipeline-webhook"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.codepipeline_project.name


  lifecycle {
    ignore_changes = [
      authentication_configuration
    ]
  }

  authentication_configuration {
    secret_token     = var.webhook_secret
    allowed_ip_range = var.webhook_ip_range
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/${var.github_branch}"
  }
}

# GitHub Webhook
resource "github_repository_webhook" "github_webhook" {
  repository = var.github_repo

  configuration {
    url          = aws_codepipeline_webhook.codepipeline_webhook.url
    content_type = "form"
    insecure_ssl = true
    secret       = var.webhook_secret
  }

  events = ["push"]
}
