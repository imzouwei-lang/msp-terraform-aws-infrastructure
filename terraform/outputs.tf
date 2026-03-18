output "s3_bucket_1_name" {
  description = "S3 存储桶 1 名称"
  value       = aws_s3_bucket.msp_bucket_1.id
}

output "s3_bucket_2_name" {
  description = "S3 存储桶 2 名称"
  value       = aws_s3_bucket.msp_bucket_2.id
}
