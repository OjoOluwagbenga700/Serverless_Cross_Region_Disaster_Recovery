variable "bucket_name" {
    description = "Name of the S3 bucket"
    type        = string
    default     = "frontend-bucket-007"
}
variable "region" {
    description = "AWS region"
    type        = string
    default     = "us-east-1"
}