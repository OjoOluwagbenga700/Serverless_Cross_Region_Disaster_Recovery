output "certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.acm_certificate.arn
}

output "certificate_validation_arn" {
  description = "The ARN of the ACM certificate validation"
  value       = aws_acm_certificate_validation.acm_certificate_validation.certificate_arn

}