output "instance_ip_addr" {
  value = aws_instance.bastion.private_ip
}

output "instance_ip_addr_public" {
  value = aws_instance.bastion.public_ip
}

