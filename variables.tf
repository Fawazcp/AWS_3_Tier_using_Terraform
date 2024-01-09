variable "bucket_name" {
  description = "Name for the S3 Bucket"
  type        = string
  default     = "s3-bucket-for-3-tier-app"
}

variable "role_name" {
  description = "Name for the IAM role"
  type        = string
  default     = "iam-role-3-tier-app"
}