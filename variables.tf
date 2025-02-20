variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# Set to false to skip PrivateLink demo
variable "deploy_privatelink_demo" {
  description = "Whether to deploy the PrivateLink demo resources"
  type        = bool
  default     = true
}

# Set this to false to disable the NAT Gateway module
variable "deploy_nat_demo" {
  description = "Whether to deploy the NAT Gateway demo resources"
  type        = bool
  default     = true
}

variable "privatelink_vpc_cidr" {
  description = "CIDR block for PrivateLink demo VPC"
  type        = string
  default     = "10.0.0.0/20"
}

variable "nat_vpc_cidr" {
  description = "CIDR block for NAT Gateway demo VPC"
  type        = string
  default     = "172.16.0.0/20"
}