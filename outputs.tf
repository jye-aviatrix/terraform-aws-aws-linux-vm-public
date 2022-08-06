output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = local.public_ip
}

output "private_ip" {
  value = aws_instance.this.private_ip
}

output "ssh" {
  value = "ssh -i ${var.key_name}.pem ubuntu@${local.public_ip}"
}