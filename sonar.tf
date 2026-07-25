resource "aws_instance" "mySonarInstance" {
  ami                    = "ami-0ee23bfc74a881de5"
  key_name               = var.key_name
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sonar-sg-2022.id]

  tags = {
    Name = "sonar_instance"
  }
}

resource "aws_security_group" "sonar-sg-2022" {
  name        = "security_sonar_group_2022"
  description = "Security group for SonarQube"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic from SonarQube server
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

# Create Elastic IP address for SonarQube instance
resource "aws_eip" "mySonarInstance" {
  instance = aws_instance.mySonarInstance.id
  domain   = "vpc"

  tags = {
    Name = "sonar_elastic_ip"
  }
}
