output "codebuild_iam_role" {
  value = aws_iam_role.codebuild_role.name
}

output "codebuild_project_name" {
  value = aws_codebuild_project.codebuild_project.name
}