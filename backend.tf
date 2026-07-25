terraform {
  backend "s3" {
    bucket         = "iykmba-terraform-state-094794930722"
    key            = "main"
    region         = "us-east-2"
    dynamodb_table = "my-dynamo-db-table-tf"
    encrypt        = true
  }
}
