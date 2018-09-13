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

variable "vpc_id" {
  description = "AWS VPC ID"
  default = "vpc-02a9e259e7acb0d5f"
}
variable "public1" {
  default = "10.0.16.0/22"
}
variable "public2" {
  default = "10.0.32.0/22"
}
variable "public3" {
  default = "10.0.48.0/22"
}
variable "private1" {
  default = "10.0.64.0/20"
}
variable "private2" {
  default = "10.0.80.0/20"
}
variable "private3" {
  default = "10.0.96.0/20"
}

/*variable "privatesubnets" {
  cidr_blocks = ["${var.private1}", "${var.private2}","${var.private3}" ]
  
}*/
