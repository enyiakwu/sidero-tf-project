terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket         = "sidero1"
    key            = "terraform-state/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}