# Instances
resource "aws_instance" "web-server-1" {
    ami = "${var.debian-ami}"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.main-int-a.id}"
    disable_api_termination = false
    key_name = "${aws_key_pair.main.key_name}"
    vpc_security_group_ids = [
        "${aws_security_group.basic.id}",
        "${aws_security_group.http-from-alb.id}"
    ]
    user_data = "${data.template_file.cloudconfig.rendered}"
    tags {
        Name = "web-server-1"
    }
    root_block_device {
        volume_type = "gp2"
        volume_size = 8
        delete_on_termination = true
    }
}

# Security groups
resource "aws_security_group" "basic" {
    vpc_id = "${aws_vpc.main.id}"
    name = "basic"
    description = "Default SG with no ingress rules"
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "basic"
    }
}

resource "aws_security_group" "http-from-alb" {
    vpc_id = "${aws_vpc.main.id}"
    name = "http-from-alb"
    description = "Allow HTTP access from ALB"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = ["${aws_security_group.alb-http.id}"]
    }
    tags {
        Name = "http-from-alb"
    }
}

resource "aws_security_group" "alb-http" {
    vpc_id = "${aws_vpc.main.id}"
    name = "alb-http"
    description = "Allow HTTP access to ALB"
    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "alb-http"
    }
}
