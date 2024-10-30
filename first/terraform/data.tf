data "aws_availability_zones" "available" {
}

data "aws_vpc" "default" {
  default = true
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# data "aws_subnet" "default_subnet_az_a" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]  # Replace with your VPC ID
#   }
#
#   filter {
#     name   = "availability-zone"
#     values = ["us-west-2a"]  # Replace with your desired AZ
#   }
#
#   filter {
#     name   = "default-for-az"
#     values = ["true"]
#   }
# }
