output "s3_bucket_1_name" {
  description = "S3 bucket 1 name"
  value       = aws_s3_bucket.msp_bucket_1.id
}

output "s3_bucket_1_arn" {
  description = "S3 bucket 1 ARN"
  value       = aws_s3_bucket.msp_bucket_1.arn
}

output "s3_bucket_2_name" {
  description = "S3 bucket 2 name"
  value       = aws_s3_bucket.msp_bucket_2.id
}

output "s3_bucket_2_arn" {
  description = "S3 bucket 2 ARN"
  value       = aws_s3_bucket.msp_bucket_2.arn
}
