provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

resource "aws_iam_user" "aubrey" {
  name = "aubrey01"
  path = "/system/"
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "region" {
        default = "us-east-1"
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "sandboxworms-tf-lock-0911" {
  name = "sandboxworms-tf-lock-0911"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
  tags {
    Name = "DynamoDB Terraform State Lock Table"
  }
}