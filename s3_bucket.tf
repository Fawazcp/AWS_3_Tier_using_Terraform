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
  bucket   = aws_s3_bucket.s3-bucket.id
  key      = "app-tier/${each.value}"
  source   = "app-tier/${each.value}"
  etag     = filemd5("app-tier/${each.value}")

  depends_on = [aws_s3_bucket.s3-bucket]
}

resource "aws_s3_bucket_object" "file_upload_s3_2" {
  bucket = aws_s3_bucket.s3-bucket.id
  key    = "nginx.conf"
  source = "nginx.conf"
  etag   = filemd5("nginx.conf")

  depends_on = [aws_s3_bucket.s3-bucket]
}

resource "aws_s3_bucket_object" "files-upload-s3_3" {

  for_each = fileset("web-tier/", "**/*")
  bucket   = aws_s3_bucket.s3-bucket.id
  key      = "web-tier/${each.value}"
  source   = "web-tier/${each.value}"
  etag     = filemd5("web-tier/${each.value}")

  depends_on = [aws_s3_bucket.s3-bucket]
}