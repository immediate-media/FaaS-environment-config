provider "github" {
  token = var.github_auth_token
  owner = "immediate-media"
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
