resource "aws_instance" "web01" {

    ami = "ami-6871a115" #redhat linux

    #availability_zone = "${data.aws_availability_zones.available.names[0]}"  #subnet id should set it.

    instance_type = "t2.micro"

    #key_name = "${var.aws_key_name}"

    #vpc_security_group_ids = ["${data.aws_security_group.privateInstanceSG.id}"]

    #subnet_id = "${data.aws_subnet.private_sub1.id}"

    tags {

        Type = "WebServer"

    }

}

resource "aws_instance" "web02" {

    ami = "ami-6871a115" #redhat linux

    #availability_zone = "${data.aws_availability_zones.available.names[0]}"  #subnet id should set it.

    instance_type = "t2.micro"

    #key_name = "${var.aws_key_name}"

    #vpc_security_group_ids = ["${data.aws_security_group.privateInstanceSG.id}"]

    #subnet_id = "${data.aws_subnet.private_sub1.id}"

    tags {

        Type = "WebServer"

    }

}