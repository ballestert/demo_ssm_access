output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.demo.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.vpc.private_subnet_id
}

# Useful for troubleshooting
output "endpoint_dns_entries" {
  description = "DNS entries for the VPC endpoints"
  value = {
    ssm         = aws_vpc_endpoint.ssm.dns_entry
    ec2messages = aws_vpc_endpoint.ec2messages.dns_entry
    ssmmessages = aws_vpc_endpoint.ssmmessages.dns_entry
  }
}