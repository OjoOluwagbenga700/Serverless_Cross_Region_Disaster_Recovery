



output "bucket_name" {
  description = "s3 bucket name"
  value       = aws_s3_bucket.frontend_bucket.bucket
}
output "bucket_domain" {
  description = "s3 bucket_domain"
  value       = aws_s3_bucket_website_configuration.frontend_bucket.website_endpoint
}


output "website_url" {
  value = "http://${aws_s3_bucket.frontend_bucket.bucket}.s3-website.${var.region}.amazonaws.com"
}