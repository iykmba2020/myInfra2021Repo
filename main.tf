provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block           = "172.16.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

# Public subnet inside the custom VPC
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "main-public-subnet"
  }
}

# Internet gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-internet-gateway"
  }
}

# Route table for internet access
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "main-public-route-table"
  }
}

# Associate public subnet with route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "jenkins-sg-2022" {
  name        = var.security_group
  description = "Security group for Jenkins EC2 instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Jenkins access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group
  }
}

resource "aws_instance" "myFirstInstance" {
  ami                         = var.ami_id
  key_name                    = var.key_name
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.jenkins-sg-2022.id]
  associate_public_ip_address = true

  tags = {
    Name = var.tag_name
  }
}

resource "aws_eip" "myFirstInstance" {
  instance = aws_instance.myFirstInstance.id
  domain   = "vpc"

  depends_on = [
    aws_internet_gateway.main_igw
  ]

  tags = {
    Name = "my_elastic_ip"
  }
}
