
locals {
  eks_cluster_name = "eks-cluster"
  azs = data.aws_availability_zones.available.names
  ami_type = "AL2_ARM_64" # "AL2_x86_64" is Amazon Linux 2 AMI for amd x86
  ami = "ami-01e681f1fa83d282a" # Amazon Linux 2 AMI for arm64 "aws ssm get-parameter --name "/aws/service/eks/optimized-ami/1.30/amazon-linux-2-arm64/recommended/image_id"
  br_vars = {
    cluster_name = local.eks_cluster_name
    cluster_endpoint = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_data = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  }

  eks_version = "1.30"
  azs_for_eks = 2
}
