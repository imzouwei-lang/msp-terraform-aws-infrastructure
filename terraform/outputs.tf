output "monitoring_instance_id" {
  description = "监控服务器实例 ID"
  value       = aws_instance.monitoring.id
}

output "monitoring_public_ip" {
  description = "监控服务器公网 IP"
  value       = aws_instance.monitoring.public_ip
}

output "wiki_instance_id" {
  description = "Wiki 服务器实例 ID"
  value       = aws_instance.wiki.id
}

output "wiki_public_ip" {
  description = "Wiki 服务器公网 IP"
  value       = aws_instance.wiki.public_ip
}

output "grafana_url" {
  description = "Grafana 访问地址"
  value       = "http://${aws_instance.monitoring.public_ip}:3000"
}

output "wiki_url" {
  description = "Wiki 访问地址"
  value       = "http://${aws_instance.wiki.public_ip}"
}
