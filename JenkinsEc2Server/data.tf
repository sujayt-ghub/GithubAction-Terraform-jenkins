/*data "aws_ami" "example" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    //values = ["amzn2-ami-kernel-*-hvm-*-x86_64-gp2"]
    values = ["ami-09e6f87a47903347c"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}*/

data "aws_availability_zones" "azs" {}
