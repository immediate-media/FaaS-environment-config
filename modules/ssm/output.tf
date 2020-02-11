output "kms_key_arn" {
  value = length(aws_kms_key.kms_key) > 0 ? aws_kms_key.kms_key[0].arn : ""
}
