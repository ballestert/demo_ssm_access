# Create base VPC infrastructure
module "vpc" {
  source = "../ssm-vpc"

  vpc_cidr     = var.vpc_cidr
  aws_region   = var.aws_region
  name_prefix  = var.name_prefix
  tags         = merge(var.tags, {
    Project = "SSM-Access-NAT"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = module.vpc.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-igw"
  })
}

# Public subnet
resource "aws_subnet" "public" {
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, 0)
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-public"
  })
}

# NAT Gateway EIP
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-nat-eip"
  })
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-natgw"
  })

  depends_on = [aws_internet_gateway.main]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-public-rt"
  })
}

# Private Route Table with NAT
resource "aws_route_table" "private" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-private-rt"
  })
}

# Route table associations
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = module.vpc.private_subnet_id
  route_table_id = aws_route_table.private.id
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