output "msp01_instance_id" {
  description = "MSP01 instance ID"
  value       = aws_instance.msp01.id
}

output "msp01_public_ip" {
  description = "MSP01 public IP"
  value       = aws_instance.msp01.public_ip
}
