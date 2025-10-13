output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.rest_api_server.public_ip
}

output "api_url" {
  description = "URL to access the REST API"
  value       = "http://${aws_instance.rest_api_server.public_ip}:${var.app_port}"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.rest_api_server.public_ip}"
}

output "update_command" {
  description = "Command to update the application"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.rest_api_server.public_ip} './update-app.sh'"
}
