
# output "eks_cluster_info" {
#   value = {
#     arn = aws_eks_cluster.first_test.arn
#     endpoint = aws_eks_cluster.first_test.endpoint
#     version = aws_eks_cluster.first_test.version
#     certificate_authority = aws_eks_cluster.first_test.certificate_authority[0].data
#     vpc_config = aws_eks_cluster.first_test.vpc_config
#   }
# }


output "aws_availability_zones" {
  value = local.azs
}


output "vpc_default" {
  value = data.aws_vpc.default.id
}
