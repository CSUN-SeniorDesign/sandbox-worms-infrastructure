provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}
##################################################################################
# DATA
##################################################################################
data "aws_availability_zones" "available" {}
data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #

resource "aws_internet_gateway" "igw" {
  vpc_id = "${data.aws_vpc.selected.id}"

}

resource "aws_subnet" "public1" {
  cidr_block = "${var.public1}"
  vpc_id = "${data.aws_vpc.selected.id}"
  map_public_ip_on_launch = "true"
  availability_zone = "${data.aws_availability_zones.available.names[0]}" 
}

resource "aws_subnet" "private1" {
  cidr_block = "${var.private1}"
  vpc_id = "${data.aws_vpc.selected.id}"
  map_public_ip_on_launch = "false"
  availability_zone = "${data.aws_availability_zones.available.names[0]}" 
  
}

resource "aws_subnet" "public2" {
  cidr_block = "${var.public2}"
  vpc_id = "${data.aws_vpc.selected.id}"
  map_public_ip_on_launch = "true"
  availability_zone = "${data.aws_availability_zones.available.names[1]}" 
}
resource "aws_subnet" "private2" {
  cidr_block = "${var.private2}"
  vpc_id = "${data.aws_vpc.selected.id}"
  map_public_ip_on_launch = "false"
  availability_zone = "${data.aws_availability_zones.available.names[1]}" 
}

resource "aws_subnet" "public3" {
  cidr_block = "${var.public3}"
  vpc_id = "${data.aws_vpc.selected.id}"
  map_public_ip_on_launch = "true"
  availability_zone = "${data.aws_availability_zones.available.names[2]}" 
}
resource "aws_subnet" "private3" {
  cidr_block = "${var.private3}"
  vpc_id = "${data.aws_vpc.selected.id}"
  map_public_ip_on_launch = "false"
  availability_zone = "${data.aws_availability_zones.available.names[2]}" 
}

# ROUTING #
resource "aws_route_table" "rtb" {
  vpc_id = "${data.aws_vpc.selected.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_route_table_association" "rta-public1" {
  subnet_id      = "${aws_subnet.public1.id}"
  route_table_id = "${aws_route_table.rtb.id}"
}
resource "aws_route_table_association" "rta-public2" {
  subnet_id      = "${aws_subnet.public2.id}"
  route_table_id = "${aws_route_table.rtb.id}"
}
resource "aws_route_table_association" "rta-public3" {
  subnet_id      = "${aws_subnet.public3.id}"
  route_table_id = "${aws_route_table.rtb.id}"
}
/*
resource "aws_route_table" "natted" {
  vpc_id = "${data.aws_vpc.selected.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = #EIP of the EC2 Instance for Natting
  }
}
*/

# SECURITY GROUPS #

resource "aws_security_group" "NATSG" {
  name = "natsg"
  vpc_id = "${data.aws_vpc.selected.id}"
  
  #allow inbound http traffic from servers in the private subnet
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = "${var.privatesubnets}"

  }
  
}

