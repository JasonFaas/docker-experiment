resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
  # addon_version = "v1.10.0-eksbuild.1"  # Specify the desired version

  tags = {
    Name = "vpc-cni-addon"
  }
}
