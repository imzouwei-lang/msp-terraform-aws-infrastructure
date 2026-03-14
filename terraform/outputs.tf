output "msp01_instance_id" {
  description = "msp01 实例 ID"
  value       = aws_instance.msp01.id
}

output "msp01_public_ip" {
  description = "msp01 公网 IP"
  value       = aws_instance.msp01.public_ip
}
