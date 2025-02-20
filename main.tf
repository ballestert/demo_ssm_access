terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Environment = "Demo"
      ManagedBy   = "Terraform"
    }
  }
}

# Get the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Deploy PrivateLink Demo if enabled
module "privatelink_demo" {
  count  = var.deploy_privatelink_demo ? 1 : 0
  source = "./modules/ssm-privatelink"

  vpc_cidr     = var.privatelink_vpc_cidr
  aws_region   = var.aws_region
  name_prefix  = "ssm-privatelink-demo"
  ami_id       = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  tags = {
    Demo = "SSM-PrivateLink"
  }
}

# Deploy NAT Gateway Demo if enabled
module "nat_demo" {
  count  = var.deploy_nat_demo ? 1 : 0
  source = "./modules/ssm-nat"

  vpc_cidr     = var.nat_vpc_cidr
  aws_region   = var.aws_region
  name_prefix  = "ssm-nat-demo"
  ami_id       = data.aws_ami.amazon_linux_2023.id
  instance_type = "m5.xlarge"

  tags = {
    Demo = "SSM-NAT"
  }
}