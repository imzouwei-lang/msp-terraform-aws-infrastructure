output "s3_bucket_name" {
  description = "S3 存储桶名称"
  value       = aws_s3_bucket.msp_storage.bucket
}

output "msp_02_instance_id" {
  description = "MSP-02 实例 ID"
  value       = aws_instance.msp_02.id
}

output "msp_02_public_ip" {
  description = "MSP-02 公网 IP"
  value       = aws_instance.msp_02.public_ip
}
