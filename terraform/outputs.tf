output "msp_03_instance_id" {
  description = "MSP-03 实例 ID"
  value       = aws_instance.msp_03.id
}

output "msp_03_public_ip" {
  description = "MSP-03 公网 IP"
  value       = aws_instance.msp_03.public_ip
}

output "msp_04_instance_id" {
  description = "MSP-04 实例 ID"
  value       = aws_instance.msp_04.id
}

output "msp_04_public_ip" {
  description = "MSP-04 公网 IP"
  value       = aws_instance.msp_04.public_ip
}

output "msp_05_instance_id" {
  description = "MSP-05 实例 ID"
  value       = aws_instance.msp_05.id
}

output "msp_05_public_ip" {
  description = "MSP-05 公网 IP"
  value       = aws_instance.msp_05.public_ip
}
