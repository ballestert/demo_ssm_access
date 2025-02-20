# Create base VPC infrastructure
module "vpc" {
  source = "../ssm-vpc"

  vpc_cidr     = var.vpc_cidr
  aws_region   = var.aws_region
  name_prefix  = var.name_prefix
  tags         = merge(var.tags, {
    Project = "SSM-Access-PrivateLink"
  })
}

# Add HTTPS ingress rule for VPC endpoints
resource "aws_security_group_rule" "vpc_endpoints" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = module.vpc.security_group_id
  description       = "Allow HTTPS from VPC CIDR"
}

# VPC Endpoints
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [module.vpc.private_subnet_id]
  security_group_ids  = [module.vpc.security_group_id]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ssm-endpoint"
  })
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [module.vpc.private_subnet_id]
  security_group_ids  = [module.vpc.security_group_id]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ec2messages-endpoint"
  })
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [module.vpc.private_subnet_id]
  security_group_ids  = [module.vpc.security_group_id]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ssmmessages-endpoint"
  })
}

# EC2 Instance
resource "aws_instance" "demo" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id                   = module.vpc.private_subnet_id
  vpc_security_group_ids      = [module.vpc.security_group_id]
  iam_instance_profile        = module.vpc.instance_profile_name
  associate_public_ip_address = false

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-instance"
  })
}