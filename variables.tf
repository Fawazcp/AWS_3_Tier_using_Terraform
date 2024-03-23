variable "AWS_ACCESS_KEY_ID" {
  description = "AWS ACCESS KEY ID"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS SECRET ACCESS KEY"
  type        = string
}

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

variable "master_password" {
  description = "The master password for the RDS cluster"
  default = "YOUR_DATABASE_PASSWORD"
}
