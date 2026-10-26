provider "aws" {
  region = var.aws_region
}

# 0. Dynamic Official Ubuntu 22.04 LTS AMI Lookup Engine
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical's Official AWS Account Owner ID
}

# 1. Custom Virtual Private Cloud (VPC)
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "devops-capstone-vpc" }
}

# 2. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "devops-igw" }
}

# 3. Public Subnet (Pinned to us-east-1a)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "devops-public-subnet" }
}

# 4. Route Table Maps
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 5. Security Group Firewall
resource "aws_security_group" "app_sg" {
  name        = "allow_web_and_ssh"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 6. EC2 Instance Server (Pulls the image dynamically from our lookup block)
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu.id 
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = "sanni"

  tags = { Name = "DevOps-Capstone-Server" }
}

# 7. S3 Bucket Asset Repository
resource "aws_s3_bucket" "musmansanni007" {
  bucket_prefix = "devops-capstone-artifacts-"

  tags = {
    Name        = "DevOps Capstone Artifact Storage"
    Environment = "Dev"
  }
}

# 8. S3 Bucket Versioning Configuration
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.musmansanni007.id
  versioning_configuration {
    status = "Enabled"
 }
}
