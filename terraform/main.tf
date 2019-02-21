variable "profile" {}
variable "region" {}
variable "shared_credentials_file" {}

variable "dd_api_key" {}
variable "image_id" {}
variable "instance_type" {}
variable "asg_size" { default = "1" }

provider "aws" {
  shared_credentials_file = "${var.shared_credentials_file}"
  profile = "${var.profile}"
  region = "${var.region}"
}

resource "aws_security_group" "ecorp-sg" {
  name = "allow_all_for_ecorp"
  description = "Allow all web traffic"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = true
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = true
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self = true
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self = true
  }
}

resource "aws_instance" "ecorp-ec2" {
  ami           = "${var.image_id}"
  instance_type = "${var.instance_type}"
  security_groups = ["allow_all_for_ecorp"]
  user_data = "${replace(file("ignition.ign"), "DD_API_KEY", "${var.dd_api_key}")}"
  tags {
    Name = "ecorp"
  }
}
