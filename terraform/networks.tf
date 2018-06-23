# VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags {
        Name = "main"
    }
}

# Subnets
resource "aws_subnet" "main-ext-a" {
    availability_zone = "${var.az-a}"
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = false
    tags {
        Name = "main-ext-a"
    }
}

resource "aws_subnet" "main-ext-b" {
    availability_zone = "${var.az-b}"
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.100.0/24"
    map_public_ip_on_launch = false
    tags {
        Name = "main-ext-a"
    }
}

resource "aws_subnet" "main-int-a" {
    availability_zone = "${var.az-a}"
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = false
    tags {
        Name = "main-int-a"
    }
}

# Route Tables
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_internet_gateway.igw.id}"
    }
    tags {
        Name = "public"
    }
}
resource "aws_route_table_association" "main-ext-a-public" {
    subnet_id = "${aws_subnet.main-ext-a.id}"
    route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "main-ext-b-public" {
    subnet_id = "${aws_subnet.main-ext-b.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table" "nat-a" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.public-a.id}"
    }
    tags {
        Name = "nat-a"
    }
}
resource "aws_route_table_association" "main-int-a-nat-a" {
    subnet_id = "${aws_subnet.main-int-a.id}"
    route_table_id = "${aws_route_table.nat-a.id}"
}

# Gateways
resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.main.id}"
    tags {
        Name = "igw"
    }
}

resource "aws_nat_gateway" "public-a" {
    allocation_id = "${aws_eip.public-a.id}"
    subnet_id = "${aws_subnet.main-ext-a.id}"
}
resource "aws_eip" "public-a" {
    vpc = true
}
