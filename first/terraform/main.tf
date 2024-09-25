# Backend configuration to store the state file in S3
terraform {
  required_version = ">= 1.5.7"

  backend "s3" {
    bucket         = "terraform-state-files-jnf"
    key            = "docker-experiment/first/terraform.tfstate"   # The key is the path to the state file in the bucket
    region         = "us-west-2"                   # The AWS region where your S3 bucket is hosted
    encrypt        = true                          # State file should be encrypted in S3
#     dynamodb_table = "terraform-lock-table"        # Optional, for locking
  }
}

# Provider configuration
provider "aws" {
  region = "us-west-2"  # Replace with the region of your EKS cluster
}

data "aws_vpc" "default" {
  default = true
}

# # TODO: Filter for default subnets
# data "aws_subnets" "default" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }
