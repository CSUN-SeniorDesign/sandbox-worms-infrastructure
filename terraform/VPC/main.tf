provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}
##################################################################################
# DATA
##################################################################################
data "aws_availability_zones" "available" {}
#Select VPC using tag Name:Project 0
data "aws_vpc" "selected" {
  #id = "${var.vpc_id}"
  filter {
    name = "tag:Name"
    values = ["Project 0"]
  }
}

/*data "aws_subnet" "privatesub" {
  filter {
    name = "tag:subnettype"
    values = ["Private"]
  }
}*/#no need because subnet doesnt exist yet or is not preexisting

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
  tags {
    subnettype = "Public"
    Name = "public1"
  }
}

resource "aws_subnet" "private1" {
  cidr_block = "${var.private1}"
  vpc_id = "${data.aws_vpc.selected.id}"
  map_public_ip_on_launch = "false"
  availability_zone = "${data.aws_availability_zones.available.names[0]}" 
  tags {
    subnettype = "Private"
    Name = "private1"
  }
  
}

resource "aws_subnet" "public2" {
  cidr_block = "${var.public2}"
  vpc_id = "${data.aws_vpc.selected.id}"
  map_public_ip_on_launch = "true"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags {
    subnettype = "Public"
    Name = "public2"
  } 
}
resource "aws_subnet" "private2" {
  cidr_block = "${var.private2}"
  vpc_id = "${data.aws_vpc.selected.id}"
  map_public_ip_on_launch = "false"
  availability_zone = "${data.aws_availability_zones.available.names[1]}" 
  tags {
    subnettype = "Private"
    Name = "private2"
  }
}

resource "aws_subnet" "public3" {
  cidr_block = "${var.public3}"
  vpc_id = "${data.aws_vpc.selected.id}"
  map_public_ip_on_launch = "true"
  availability_zone = "${data.aws_availability_zones.available.names[2]}" 
    tags {
    subnettype = "Public"
    Name = "public3"
  }
}
resource "aws_subnet" "private3" {
  cidr_block = "${var.private3}"
  vpc_id = "${data.aws_vpc.selected.id}"
  map_public_ip_on_launch = "false"
  availability_zone = "${data.aws_availability_zones.available.names[2]}" 
  tags {
    subnettype = "Private"
    Name = "private3"
  }
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

################################################################
##### Route Table for Nat Instance #######
# Route Internet traffic of the EC2 instances in Private Subnet to the NAT Instance
resource "aws_route_table" "privatenet_nat" {
  vpc_id = "${data.aws_vpc.selected.id}"
  route {
    cidr_block = "0.0.0.0/0"
    #gateway_id = "${aws_network_interface.natinstance_eth0.id}" #https://github.com/hashicorp/terraform/issues/4987 - can only add ethernet id of the instance
    instance_id = "${aws_instance.nat.id}"
  }
  
}


resource "aws_route_table_association" "rta-private1" {
  subnet_id = "${aws_subnet.private1.id}"
  route_table_id = "${aws_route_table.privatenet_nat.id}"
}
resource "aws_route_table_association" "rta-private2" {
  subnet_id = "${aws_subnet.private2.id}"
  route_table_id = "${aws_route_table.privatenet_nat.id}"
}
resource "aws_route_table_association" "rta-private3" {
  subnet_id = "${aws_subnet.private3.id}"
  route_table_id = "${aws_route_table.privatenet_nat.id}"
}
################################################################

# SECURITY GROUPS #

resource "aws_security_group" "NATSG" {
  name = "natsg"
  vpc_id = "${data.aws_vpc.selected.id}"
  
  #allow inbound http traffic from servers in the private subnet
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.private1.cidr_block}", "${aws_subnet.private2.cidr_block}", "${aws_subnet.private3.cidr_block}"]
  }
  ingress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.private1.cidr_block}", "${aws_subnet.private2.cidr_block}", "${aws_subnet.private3.cidr_block}"]    
  }
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
          Name = "NATSG"
  }
}

resource "aws_security_group" "bastionsg" {
  name = "bastiosg"
  vpc_id = "${data.aws_vpc.selected.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
          Name = "bastionSG"
  }
}

resource "aws_security_group" "privateInstanceSG" {
  name = "privateInstanceSG"
  vpc_id = "${data.aws_vpc.selected.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.public1.cidr_block}"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.public1.cidr_block}"]
  }
  tags {
          Name = "privateInstanceSG"
  }
}


resource "aws_security_group" "albsg" {
  name = "albsg"
  vpc_id = "${data.aws_vpc.selected.id}"

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
          Name = "ALBSG"
  }
}