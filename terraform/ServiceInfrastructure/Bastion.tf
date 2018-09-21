#Bastion

resource "aws_instance" "bastion" {
  ami                         = "ami-6871a115"
  #redhat linux 
  instance_type               = "t2.micro"
  associate_public_ip_address = true
    # The name of our SSH keypair
  key_name = "${var.aws_key_name}"
    # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${data.aws_security_group.bastionhostsg.id}"]
  subnet_id = "${data.aws_subnet.public_sub1.id}"
tags {
      Name = "Bastion Host"
      Type = "BastionHost"
  }

}
output "bastion_host_public ip" {
  value = "${aws_instance.bastion.public_ip}"
}