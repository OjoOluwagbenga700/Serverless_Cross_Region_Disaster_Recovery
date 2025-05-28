
# create S3 bucket
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = var.bucket_name
}

# Bucket ownership control
resource "aws_s3_bucket_ownership_controls" "frontend_bucket" {
  bucket = aws_s3_bucket.frontend_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "public_access_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.frontend_bucket.arn}/*"
      }
    ]
  })
}

#Opening  public access 
resource "aws_s3_bucket_public_access_block" "frontend_bucket" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "frontend_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.frontend_bucket,
    aws_s3_bucket_public_access_block.frontend_bucket,
  ]

  bucket = aws_s3_bucket.frontend_bucket.id
  acl    = "public-read"
}

# Bucket website configurations
resource "aws_s3_bucket_website_configuration" "frontend_bucket" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# Upload an object
resource "aws_s3_object" "file" {
  bucket       = aws_s3_bucket.frontend_bucket.id
  key          = "index.html" # the website file
  source       = "index.html" #  the path/location of the file 
  acl          = "public-read"
  content_type = "text/html"
}