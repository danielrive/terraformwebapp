#***  VPC  Resources *****


# ---- Create VPC  --------

resource "aws_vpc" "VPC" {
  cidr_block           = var.CIDR[0]
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name       = "VPC-${var.ENVIRONMENT}"
    Created_by = "Terraform"
  }
}


# Get Region Available Zones

data "aws_availability_zones" "available" {
  state = "available"
}

#------- Public Subnets -------

# --- First Public Subnet
resource "aws_subnet" "PUBLIC_SUBNETs" {
  count                   = 2
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = cidrsubnet(aws_vpc.VPC.cidr_block, 7, count.index + 1)
  map_public_ip_on_launch = true
  tags = {
    Name       = "Subnet_Public_${count.index}_${var.ENVIRONMENT}"
    Created_by = "Terraform"
  }
}

#------- Private Subnets -------

# --- First Private Subnet
resource "aws_subnet" "PRIVATE_SUBNETs" {
  count             = 2
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = cidrsubnet(aws_vpc.VPC.cidr_block, 7, count.index + 3)
  tags = {
    Name       = "Subnet_Private_${count.index}_${var.ENVIRONMENT}"
    Created_by = "Terraform"
  }
}

#------- Internet Gateway -------

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name       = "IGW_${var.ENVIRONMENT}"
    Created_by = "Terraform"
  }
}

#------- Create Default Route Public Table -------

resource "aws_default_route_table" "RT_PUBLIC" {
  default_route_table_id = aws_vpc.VPC.default_route_table_id

  ### Internet Route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name       = "Public_RT_${var.ENVIRONMENT}"
    Created_by = "Terraform"
  }
}

#------- Create EIP -------
resource "aws_eip" "EIP" {
  vpc = true
  tags = {
    Name       = "EIP-${var.ENVIRONMENT}"
    Created_by = "Terraform"
  }
}

#------- Attach EIP to Nat Gateway -------
resource "aws_nat_gateway" "NATGW" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.PUBLIC_SUBNETs[0].id
  tags = {
    Name       = "NAT_${var.ENVIRONMENT}"
    Created_by = "Terraform"
  }
}

#------- Create Private Route Private Table -------
resource "aws_route_table" "RT_PRIVATE" {
  vpc_id = aws_vpc.VPC.id

  ### Internet Route  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NATGW.id
  }

  tags = {
    Name       = "Private_RT_${var.ENVIRONMENT}"
    Created_by = "Terraform"
  }
  depends_on = [aws_nat_gateway.NATGW]
}
#------- Private Subnets Association -------
resource "aws_route_table_association" "RT_ASS_PRIV_SUBNETs" {
  count          = 2
  subnet_id      = aws_subnet.PRIVATE_SUBNETs[count.index].id
  route_table_id = aws_route_table.RT_PRIVATE.id
  depends_on     = [aws_route_table.RT_PRIVATE]
}

#------- Public Subnets Association -------
resource "aws_route_table_association" "RT_ASS_PUB_SUBNETs" {
  count          = 2
  subnet_id      = aws_subnet.PUBLIC_SUBNETs[count.index].id
  route_table_id = aws_vpc.VPC.main_route_table_id
}

