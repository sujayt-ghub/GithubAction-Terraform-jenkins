terraform {
  backend "s3" {
    bucket = "terraform-jenkins-eks-01"
    key    = "eks/terraform.tfstate"
    region = "us-west-2"
  }
}
