output "s3_bucket_name" {
  description = "S3 存储桶名称"
  value       = aws_s3_bucket.msp_storage.bucket
}
