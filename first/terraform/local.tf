
locals {
  eks_cluster_name = "eks-cluster"
  azs = data.aws_availability_zones.available.names
  ami = "AL2_x86_64"  # Amazon Linux 2 AMI for x86
  bottlerocket_config = templatefile("bottlerocketconfig.toml.tpl", local.br_vars)
  br_vars = {
    cluster_name = local.eks_cluster_name
    cluster_endpoint = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_data = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  }

  eks_version = "1.30"
}
