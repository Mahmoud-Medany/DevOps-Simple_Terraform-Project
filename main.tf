#create s3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

# Configure ownership controls for the S3 bucket
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure public access block settings for the S3 bucket
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configure access control settings for the S3 bucket
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

# Upload the index.html file to the S3 bucket
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

# Upload the error.html file to the S3 bucket
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

# Upload the profile.jpg image to the S3 bucket
resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mybucket.id
  key = "profile.jpg"
  source = "profile.jpg"
  acl = "public-read"
}

# Configure website hosting for the S3 bucket
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  
  # Ensure ACL configuration is complete before configuring website hosting  
  depends_on = [ aws_s3_bucket_acl.example ]
}