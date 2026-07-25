variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "us-east-2"
}

variable "key_name" {
  description = "SSH key to connect to EC2 instances."
  default     = "myjenkinskey"
}

variable "instance_type" {
  description = "EC2 instance type."
  default     = "t2.micro"
}

variable "security_group" {
  description = "Name of the security group."
  default     = "jenkins-sgroup-dec-2021"
}

variable "tag_name" {
  description = "EC2 instance tag."
  default     = "my-ec2-instance"
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI for us-east-2."
  default     = "ami-074d6ada17cb05dff"
}

variable "versioning" {
  type        = bool
  description = "Enable S3 bucket versioning."
  default     = true
}

variable "acl" {
  type        = string
  description = "S3 bucket ACL."
  default     = "private"
}

variable "bucket_prefix" {
  type        = string
  description = "Creates a unique S3 bucket name."
  default     = "my-s3bucket-"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the S3 bucket."

  default = {
    environment = "DEV"
    terraform   = "true"
  }
}
