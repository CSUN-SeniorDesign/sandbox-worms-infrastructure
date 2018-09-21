resource "aws_eip" "nat_eip"{
    instance = "${aws_instance.nat.id}"
    vpc = true
}
resource "aws_eip_association" "eip_assoc"{
    instance_id = "${aws_instance.nat.id}"
    allocation_id = "${aws_eip.nat_eip.id}"
}
resource "aws_network_interface" "natinstance_eth0"{
    subnet_id = "${aws_subnet.public1.id}"
    security_groups = ["${aws_security_group.NATSG.id}"]
    source_dest_check = false
}
resource "aws_instance" "nat" {
    ami = "ami-07f163783dd09f8ad"
    availability_zone = "${data.aws_availability_zones.available.names[0]}" 
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    network_interface {
        network_interface_id = "${aws_network_interface.natinstance_eth0.id}"
        device_index = 0
    }

    tags {
        Name = "NAT_Instance"
    }
}