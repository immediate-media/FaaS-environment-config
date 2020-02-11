output "kms_key_arn" {
  value = aws_kms_key.kms_key[0].arn
}
