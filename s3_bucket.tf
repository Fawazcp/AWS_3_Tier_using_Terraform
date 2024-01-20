resource "aws_s3_bucket" "s3-bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "3TierApp"
    Environment = "dev"
  }
}

# Upload files to S3 bucket
resource "aws_s3_bucket_object" "files-upload-s3" {
  
  for_each = fileset("app-tier/", "*")
  bucket = aws_s3_bucket.s3-bucket.id
  key = "app-tier/${each.value}"
  source = "app-tier/${each.value}"
  etag = filemd5("app-tier/${each.value}")

  depends_on = [aws_s3_bucket.s3-bucket]
}