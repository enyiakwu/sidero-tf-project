# variable "public_key_path" {
#   description = <<DESCRIPTION
# Path to the SSH public key to be used for authentication.
# Ensure this keypair is added to your local SSH agent so provisioners can
# connect.

# Example: ~/.ssh/terraform.pub
# DESCRIPTION
# }

 variable "key_name" {
   description = "Desired name of AWS key pair"
   default = "oregon-kp"
 }

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
}

variable "aws_availability_zone" {
  description = "AWS Availability Zone to launch servers."
  default     = "us-west-2a"
}
variable "artifacts_bucket_name" {
  description = "AWS bucket for artifacts."
  default     = "sidero-athlone-artifacts"
}

variable "env" {
  description = "environment for terraform project."
  default     = "development"
}
variable "tf_version" {
  description = "terraform version"
  default     = "1.1.8"
}

variable "infra_project_repository_branch" {
  description = "repo target branch"
  default     = "master"
}

variable "infra_project_repository_name" {
  description = "target repo"
  default     = "sidero_athlone"
}


# Ubuntu Precise amis
variable "aws_amis" {
  default = {
    eu-west-1 = ""
    us-east-1 = ""
    us-east-2 = ""
    us-west-2 = ""
  }
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "region" {
  description = "The aws region. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html"
  type        = string
  default     = "us-west-2"
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  # description = "Name of the project deployment."
  type = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "TerraformEKSWorkshop"
    "Environment" = "Development"
    "Owner"       = "sidero athlone"
  }
}