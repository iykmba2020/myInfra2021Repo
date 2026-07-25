variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "us-east-2"
}

variable "key_name" {
  description = "SSH key pair for EC2 instances."
  default     = "myjenkinskey"
}

variable "instance_type" {
  description = "EC2 instance type."
  default     = "t2.micro"
}

variable "security_group" {
  description = "Name of the Jenkins security group."
  default     = "jenkins-sgroup-dec-2021"
}

variable "tag_name" {
  description = "Tag name for the EC2 instance."
  default     = "my-ec2-instance"
}

variable "ami_id" {
  description = "Ubuntu AMI ID for us-east-2."
  default     = "ami-0d1b5a8c13042c939"
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
  description = "Unique prefix for the S3 bucket."
  default     = "my-s3bucket-"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the S3 bucket."

  default = {
    environment = "DEV"
    terraform   = "true"
  }
}
