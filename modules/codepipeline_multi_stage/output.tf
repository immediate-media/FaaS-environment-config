output "codepipeline_iam_role" {
  value = aws_iam_role.codepipeline_role.name
}