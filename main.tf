terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "remote" {
    organization = "devopswithlasantha"

    workspaces {
      name = "3tierapptf-workspace"
    }
  }
}


provider "aws" {
  region = "us-east-2"
}

# S3 bucket creation
resource "aws_s3_bucket" "s3-bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "3TierApp"
    Environment = "dev"
  }
}

# EC2 instance profile creation
resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-profile"
  role = aws_iam_role.iamrole.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iamrole" {
  name               = var.role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = {
    Name        = "3TierApp"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "attach_policy1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.iamrole.name
  depends_on = [aws_iam_role.iamrole]
}

resource "aws_iam_role_policy_attachment" "attach_policy2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.iamrole.name
  depends_on = [aws_iam_role.iamrole]
}

# VPC Creation
resource "aws_vpc" "aws-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name        = "3TierApp"
    Environment = "dev"
  }
}

# Subnets Creation
resource "aws_subnet" "public-web-az1" {
  vpc_id            = aws_vpc.aws-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name        = "Public-Web-Subnet-AZ-1"
    Environment = "dev"
  }
}

resource "aws_subnet" "public-web-az2" {
  vpc_id            = aws_vpc.aws-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2b"

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