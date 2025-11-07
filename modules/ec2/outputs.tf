output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.streamlit_host.id
}

output "public_ip" {
  description = "Public IP of the Streamlit EC2 instance"
  value       = aws_instance.streamlit_host.public_ip
}

output "role_name" {
  description = "Name of the IAM role assigned to the instance"
  value       = aws_iam_role.role_streamlit_app.name
}

output "public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.streamlit_host.public_dns
}