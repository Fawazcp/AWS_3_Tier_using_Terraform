output "bucket_name" {
  description = "Bucket Name"
  value       = aws_s3_bucket.s3-bucket.id
}

output "role_name" {
  description = "Iam Role"
  value       = aws_iam_role.iamrole.name
}

output "vpc_id" {
  description = "vpc"
  value       = aws_vpc.aws-vpc.id
}