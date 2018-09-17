#Service instance 1

resource "aws_instance" "service Instance 1" {
ami           = "ami-6871a115"
instance_type = "t2.micro"
availability_zone = "us-east-1b"
subnet_id = "subnet-047a3c4852741bde2"
tags {
Name = "Service 1"}

}

