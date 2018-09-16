#Bastion

resource "aws_instance" "bastion" {
  ami                         = "ami-04681a1dbd79675a5"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  #key_name = "${var.key_name}"
  #vpc_security_group_ids=["sg-7cad580b","sg-91edb3e4"]
  subnet_id="subnet-022378249a6d9694f"
tags {
      Name = "Bastion Host"
  }

}
