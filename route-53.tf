resource "aws_route53_record" "component" {
  zone_id = data.terraform_remote_state.vpc.outputs.PRIVATE_ALB_ADDRESS
  name    = "${var.COMPONENT}-dev.roboshop.internal"
  type    = "CNAME"
  ttl     = 10
  records = [data.terraform_remote_state.alb.outputs.PRIVATE_ALB_ADDRESS]
}