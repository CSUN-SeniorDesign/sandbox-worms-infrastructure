data "aws_security_group" "bastionhostsg"{
    filter {
        name = "tag:Name"
        values = ["bastionSG"]
    }
}
data "aws_security_group" "privateInstanceSG" {
    filter {
        name = "tag:Name"
        values = ["privateInstanceSG"]
    }
}
data "aws_subnet" "private_sub1"{
    filter {
        name = "tag:Name"
        values = ["private1"]
    }
}

data "aws_subnet" "public_sub1"{
    filter {
        name = "tag:Name"
        values = ["public1"]
    }
}

data "aws_subnet" "public_sub2"{
    filter {
        name = "tag:Name"
        values = ["public2"]
    }
}
resource "aws_instance" "web01" {
    ami = "ami-6871a115" #redhat linux
    #availability_zone = "${data.aws_availability_zones.available.names[0]}"  #subnet id should set it.
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${data.aws_security_group.privateInstanceSG.id}"]
    subnet_id = "${data.aws_subnet.private_sub1.id}"
    tags {
        Type = "WebServer"
    }
}
resource "aws_instance" "web02" {
    ami = "ami-6871a115" #redhat linux
    #availability_zone = "${data.aws_availability_zones.available.names[0]}"  #subnet id should set it.
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${data.aws_security_group.privateInstanceSG.id}"]
    subnet_id = "${data.aws_subnet.private_sub1.id}"
    tags {
        Type = "WebServer"
    }
}

/*resource "aws_instance" "bastion_host" {
    ami = "ami-6871a115" #redhat linux
    #availability_zone = "${data.aws_availability_zones.available.names[0]}"  #subnet id should set it.
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${data.aws_security_group.bastionhostsg.id}"]
    subnet_id = "${data.aws_subnet.public_sub1.id}"
    tags {
        Type = "BastionHost"
    }
   /* provisioner "local-exec" {
        command = "sed -ri 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/${aws_instance.bastion_host.public_ip}/g ~/.ssh/config"
    }*/
#}
/*
output "bastion_host_public ip" {
  value = "${aws_instance.bastion_host.public_ip}"
}
*/
