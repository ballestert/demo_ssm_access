variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "name_prefix" {
  description = "Prefix to be used for resource names"
  type        = string
  default     = "ssm-privatelink-demo"
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

variable "ami_id" {
  description = "ID of the AMI to use for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}