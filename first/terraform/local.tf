
locals {
  eks_cluster_name = "first-eks-cluster"
  azs = data.aws_availability_zones.available.names
}