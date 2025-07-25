# VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.azs.names
  public_subnets = var.public_subnets
  map_public_ip_on_launch = true

  enable_dns_hostnames = true

  tags = {
    Name        = "jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "jenkins-subnet"
  }
}

# SG
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-sg"
  description = "Security Group for Jenkins Server"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name = "jenkins-sg"
  }
}

/*# EC2
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "Jenkins-Server"

  instance_type               = "t2.micro"
  ami                         = "ami-09e6f87a47903347c"
  key_name                    = "jenkins-server-key"
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("jenkins-install.sh")
  availability_zone           = data.aws_availability_zones.azs.names[0]

  tags = {
    Name        = "Jenkins-Server"
    Terraform   = "true"
    Environment = "dev"
  }
}*/
/*module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name                   = "single-instance"          
  ami                    = "ami-09e6f87a47903347c"
  instance_type          = "t2.micro"
  key_name               = "jenkins-server-key"
  monitoring             = true
  //sg                     = [module.sg.security_group_id]
 //vpc_security_group_ids = [module.sg.security_group_id]
  //subnet_id              = module.vpc.public_subnets[0]
  //availability_zone      = data.aws_availability_zones.azs.names[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}*/
/*resource "aws_instance" "webser" {
  ami           = "ami-09e6f87a47903347c"
  instance_type = "t2.micro"
  key_name      = "jenkins-server-key"
  monitoring    = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]

  tags = {
    Name = "HelloWorld"
  }
}*/

module "instance" {
  //source  = "terraform-aws-modules/ec2-instance/aws"
  source = "cloudposse/ec2-instance/aws"

  name = "single-aws-instance"
  ami           = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"
  ssh_key_pair      = "jenkins-server-key"
  monitoring    = true
  vpc_id        = module.vpc.vpc_id
  security_groups    = [module.sg.security_group_id]
  subnet                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  root_volume_size = 25
  user_data      = file("jenkins-ubuntu.sh")

  tags = {
    Name = "HelloWorld"
  }
}
