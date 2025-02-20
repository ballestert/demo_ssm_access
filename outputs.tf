output "privatelink_instance_id" {
  description = "ID of the EC2 instance in PrivateLink demo"
  value       = var.deploy_privatelink_demo ? module.privatelink_demo[0].instance_id : null
}

output "nat_instance_id" {
  description = "ID of the EC2 instance in NAT Gateway demo"
  value       = var.deploy_nat_demo ? module.nat_demo[0].instance_id : null
}