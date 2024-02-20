output "url" {
  value = "http://${aws_eip.configu.public_dns}"
}

output "public_ip" {
  value = aws_eip.configu.public_ip
}

output "private_key" {
  value     = tls_private_key.configu.private_key_pem
  sensitive = true
}

# Getting the output from private key is via this command below:

# terraform output -raw private_key