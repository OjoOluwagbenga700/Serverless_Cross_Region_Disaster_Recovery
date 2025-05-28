output "bucket_arn" {
  description = "s3 bucket_arn"
  value       = aws_s3_bucket.frontend_bucket
}

output "bucket_name" {
  description = "s3 bucketid"
  value       = aws_s3_bucket.frontend_bucket.id
}
