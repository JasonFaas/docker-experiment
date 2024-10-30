
resource "aws_subnet" "public_subnet" {
  count = local.azs_for_eks

  vpc_id                  = data.aws_vpc.default.id
  cidr_block = ["172.31.64.0/20", "172.31.80.0/20"][count.index]  # Public subnet CIDR blocks

  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true  # Private subnets don't assign public IPs

  tags = {
    Name                             = "eks-public-subnet-${local.azs[count.index]}"
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"  = "1"  # Needed for internal load balancers in EKS
  }
}

# data "aws_subnets" "default" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }
