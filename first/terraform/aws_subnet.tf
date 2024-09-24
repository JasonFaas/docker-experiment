# TODO: Have to create my own subnets
# TODO: Then add tags so that the eks node instances can connect to them.
# TODO: Also, be sure to remove all the default subnet references to ensure other resources are not using them.

data "aws_availability_zones" "available" {

}

resource "aws_subnet" "private_subnet" {
  for_each = toset(data.aws_availability_zones.available.names)  # Loop through available AZs

  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index + 1)
  availability_zone       = each.key
  map_public_ip_on_launch = false  # Private subnets don't assign public IPs

  tags = {
    Name                             = "eks-private-subnet-${each.key}"
    "kubernetes.io/cluster/my-cluster" = "shared"
    "kubernetes.io/role/internal-elb"  = "1"  # Needed for internal load balancers in EKS
  }
}