output "msp_06_public_ip" {
  description = "MSP-06 server public IP"
  value       = aws_instance.msp_06.public_ip
}

output "msp_06_instance_id" {
  description = "MSP-06 server instance ID"
  value       = aws_instance.msp_06.id
}
