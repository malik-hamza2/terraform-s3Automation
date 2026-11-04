output "bucket_names" {
  description = "Bucket name per environment"
  value       = { for env, b in aws_s3_bucket.bucket : env => b.bucket }
}

output "bucket_arns" {
  description = "Bucket ARN per environment"
  value       = { for env, b in aws_s3_bucket.bucket : env => b.arn }
}