resource "aws_instance" "mySonarInstance" {
  ami                         = var.ami_id
  key_name                    = var.key_name
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.sonar-sg-2022.id]
  associate_public_ip_address = true

  tags = {
    Name = "sonar_instance"
  }
}

resource "aws_security_group" "sonar-sg-2022" {
  name        = "security_sonar_group_2022"
  description = "Security group for SonarQube"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SonarQube access"
    from_port   = 9000
    to_port     = 9000
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
    Name = "security_sonar"
  }
}

resource "aws_eip" "mySonarInstance" {
  instance = aws_instance.mySonarInstance.id
  domain   = "vpc"

  depends_on = [
    aws_internet_gateway.main_igw
  ]

  tags = {
    Name = "sonar_elastic_ip"
  }
}
