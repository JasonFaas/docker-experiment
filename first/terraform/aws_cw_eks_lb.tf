# As this is a classic Load Balancer, there isn't much terraform support
# See difference in following commands:
# aws elbv2 describe-load-balancers
# aws elb describe-load-balancers

# # # terraform resource for cloudwatch alarm based on load balancer in us-west-2a az instance being out of service
# # resource "aws_cloudwatch_metric_alarm" "out_of_service" {
# #   alarm_name          = "eks-lb-instance-2a-out-of-service"
# #   comparison_operator = "GreaterThanThreshold"
# #   evaluation_periods  = 1
# #   datapoints_to_alarm = 1
# #   metric_name         = "UnHealthyHostCount"
# #   namespace           = "AWS/ELB"
# #   period              = 60 * 5
# #   statistic           = "Sum"
# #   threshold           = 0
# #   dimensions = {
# #     AvailabilityZone = "us-west-2a"
# #     LoadBalancerName = data.aws_lb.lb_for_eks_deployment.name
# #   }
# #   treat_missing_data = "notBreaching"
# # }
#
# # data resource for all load balancers
# data "aws_lbs" "lb_for_eks_deployment" {
#   # tags = {
#   #   "kubernetes.io/service-name" = "default/flask-api-service"
#   # }
# }
# output "what" {
#   value = data.aws_lbs.lb_for_eks_deployment.arns
# }
#
# # data aws_lb "lb_for_eks_deployment" {
# #   arn = data.aws_lbs.lb_for_eks_deployment.arns
# # }
