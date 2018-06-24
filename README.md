# Terraform configuration for serving simple html file

Running `build.sh` will apply terraform state if aws credentials are configured or if specified via environment variables.
Public ssh key is extracted from `${HOME}/.ssh/id_rsa.pub`, use `SSH_PUBLIC_KEY` environment variable to override it (or if there is no key in home directory)

# Implementation details
Resources described in terraform:
* vpc
* 2 public networks (those which are routed using internet gateway)
* 1 internal network (which is routed via nat gateway)
* 2 route tables (for internal and external networks)
* NAT Gateway
* Internet Gateway
* 1 instances, configured via cloud-init
* 3 security groups (2 for instance and 1 for ALB)
* Aplication Load Balancer listning for HTTP with instance as a backend

Cloud-init config is passed via user data, and generated using templating abilities of terraform from following files:
* `terraform/includes/cloudconfig.template`
* `terraform/includes/indexhtml.template`
* `terraform/includes/nginxconf.template`

Cloud-init does the following:
* installs docker-ce
* creates image from nginx image, adding custom configuration and one html file
* launches container from that image

Nginx is configured to servie files from directory, where there is one .html file. It also answers `200 OK` to requests to `/ping` for ALB healthchecks
