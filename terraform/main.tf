provider "aws" {}

variable "az-a" {
    type = "string"
    default = "eu-central-1a"
}
variable "az-b" {
    type = "string"
    default = "eu-central-1b"
}

variable "debian-ami" {
    type = "string"
    default = "ami-9025167b"
}

variable "ssh-public-key" {
    type = "string"
    default = ""
}

resource "aws_key_pair" "main" {
    key_name = "main"
    public_key = "${var.ssh-public-key}"
}

data "template_file" "cloudconfig" {
    template = "${file("${path.module}/includes/cloudconfig.template")}"
    
    vars {
        nginxconf = "${data.template_file.nginxconf.rendered}"
        indexhtml = "${data.template_file.indexhtml.rendered}"
    }
}

data "template_file" "nginxconf" {
    template = "${file("${path.module}/includes/nginxconf.template")}"
}

data "template_file" "indexhtml" {
    template = "${file("${path.module}/includes/indexhtml.template")}"
}
