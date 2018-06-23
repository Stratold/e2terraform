resource "aws_alb" "theonly" {
    name = "theonly"
    internal = false
    ip_address_type = "ipv4"
    security_groups = [
        "${aws_security_group.alb-http.id}"
    ]
    subnets = [
        "${aws_subnet.main-ext-a.id}",
        "${aws_subnet.main-ext-b.id}"
    ]
    enable_deletion_protection = false
    enable_cross_zone_load_balancing = true
}
resource "aws_alb_listener" "theonly-http" {
    load_balancer_arn = "${aws_alb.theonly.arn}"
    port = "80"
    protocol = "HTTP"
    default_action {
        target_group_arn = "${aws_alb_target_group.theonly.arn}"
        type = "forward"
    }
}
resource "aws_alb_target_group" "theonly" {
    name = "theonly"
    port = 80
    protocol = "HTTP"
    vpc_id = "${aws_vpc.main.id}"
    
    health_check {
        path = "/ping"
    }
}
resource "aws_alb_target_group_attachment" "theonly-web-server-1" {
    target_group_arn = "${aws_alb_target_group.theonly.arn}"
    target_id = "${aws_instance.web-server-1.id}"
    port = 80
}
