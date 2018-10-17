variable "bucket" {
  description = "AWS S3 Bucket name for Terraform state"
}
variable "dynamodb_table" {
  description = "AWS DynamoDB table for state locking"
}
variable "key" {
  description = "Key for Terraform state at S3 bucket"
}
variable "profile" {
  description = "AWS profile"
}
variable "region" {
  description = "AWS Region"
}
variable "aws_access_key" {}

variable "aws_secret_key" {}
variable "aws_key_name" {
  default = "proj0_aubrey"
}
variable "ecs_ami" {
  default = "ami-0b9a214f40c38d5eb"
}
variable "ecs_instance_type" {
  default = "t2.micro"
}

variable "ecs_cluster" {
  default = "sbw-ecs-cluster"
}