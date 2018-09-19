#Bastion

resource "aws_instance" "bastion" {

  #redhat linux 
  ami                         = "ami-6871a115" 
  
  instance_type               = "t2.micro"
  
  associate_public_ip_address = true
  
  # The name of our SSH keypair
  key_name                    = "${var.aws_key_name}"
  
  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids     =  ["${data.aws_security_group.bastionhostsg.id}"]
  
  subnet_id                   = "${data.aws_subnet.public_sub1.id}"
  Type                        = "BastionHost"
  tags {
      Name = "Bastion Host"
       }

}

output "bastion_host_public ip" {
  value = "${aws_instance.bastion_host.public_ip}"
}