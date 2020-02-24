output "kms_key_arn" {
  value = length(aws_kms_key.kms_key) > 0 ? aws_kms_key.kms_key[0].arn : ""
}

output "ssm_key_arn" {
  value = length(aws_kms_key.kms_key) > 0 ? aws_ssm_parameter.ssm_ps_prod[0].arn : ""
}

output "ssm_name_arn" {
  value = length(aws_kms_key.kms_key) > 0 ? aws_ssm_parameter.ssm_ps_prod[0].name : ""
}

