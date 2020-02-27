output "url" {
  value       = "http://${aws_route53_record.this.name}.${var.r53-zone}:2048/"
  description = "URL under which the web app is reachable."
}
