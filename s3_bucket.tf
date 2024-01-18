resource "aws_s3_bucket" "s3-bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "3TierApp"
    Environment = "dev"
  }
}