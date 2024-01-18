# VPC Creation
resource "aws_vpc" "aws-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "3TierApp"
    Environment = "dev"
  }
}

# Subnets Creation
resource "aws_subnet" "public-web-az1" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "Public-Web-Subnet-AZ-1"
    Environment = "dev"
  }
}

resource "aws_subnet" "public-web-az2" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "Public-Web-Subnet-AZ-2"
    Environment = "dev"
  }
}

resource "aws_subnet" "private-app-az1" {
  vpc_id            = aws_vpc.aws-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name        = "Private-App-Subnet-AZ-1"
    Environment = "dev"
  }
}

resource "aws_subnet" "private-app-az2" {
  vpc_id            = aws_vpc.aws-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name        = "Private-App-Subnet-AZ-2"
    Environment = "dev"
  }
}

resource "aws_subnet" "private-db-az1" {
  vpc_id            = aws_vpc.aws-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name        = "Private-Db-Subnet-AZ-1"
    Environment = "dev"
  }
}

resource "aws_subnet" "private-db-az2" {
  vpc_id            = aws_vpc.aws-vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name        = "Private-Db-Subnet-AZ-2"
    Environment = "dev"
  }
}

# IGW Creation
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "Three-Tier-IGW"
    Environment = "dev"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.nat_eip_az1.id
  subnet_id     = aws_subnet.public-web-az1.id

  tags = {
    Name        = "Three-Tier-NAT-AZ1"
    Environment = "dev"
  }
}

resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.nat_eip_az2.id
  subnet_id     = aws_subnet.public-web-az2.id

  tags = {
    Name        = "Three-Tier-NAT-AZ2"
    Environment = "dev"
  }
}

resource "aws_eip" "nat_eip_az1" {
}

resource "aws_eip" "nat_eip_az2" {
}

# Route Table for Public Subnets
resource "aws_route_table" "public_subnet_route_table_az1" {
  vpc_id = aws_vpc.aws-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name        = "Public-Subnet-Route-Table-AZ1"
    Environment = "dev"
  }
}

resource "aws_route_table" "public_subnet_route_table_az2" {
  vpc_id = aws_vpc.aws-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name        = "Public-Subnet-Route-Table-AZ2"
    Environment = "dev"
  }
}

# Public Route Tables Attach Public Subnets
resource "aws_route_table_association" "public_subnet_route_table_az1" {
  subnet_id      = aws_subnet.public-web-az1.id
  route_table_id = aws_route_table.public_subnet_route_table_az1.id
}

resource "aws_route_table_association" "public_subnet_route_table_az2" {
  subnet_id      = aws_subnet.public-web-az2.id
  route_table_id = aws_route_table.public_subnet_route_table_az2.id
}

# Route Table for Private Subnets
resource "aws_route_table" "private_subnet_route_table_az1" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "Private-Subnet-Route-Table-AZ1"
    Environment = "dev"
  }
}

resource "aws_route_table" "private_subnet_route_table_az2" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "Private-Subnet-Route-Table-AZ2"
    Environment = "dev"
  }
}

# Private Route Tables Attach NAT
resource "aws_route" "private_subnet_route_az1" {
  route_table_id         = aws_route_table.private_subnet_route_table_az1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_az1.id
}

resource "aws_route" "private_subnet_route_az2" {
  route_table_id         = aws_route_table.private_subnet_route_table_az2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_az2.id
}

# Private Route Tables Attach Private Subnet
resource "aws_route_table_association" "private_subnet_association_az1" {
  subnet_id      = aws_subnet.private-app-az1.id
  route_table_id = aws_route_table.private_subnet_route_table_az1.id
}

resource "aws_route_table_association" "private_subnet_association_az2" {
  subnet_id      = aws_subnet.private-app-az2.id
  route_table_id = aws_route_table.private_subnet_route_table_az2.id
}
