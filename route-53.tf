resource "aws_route53_record" "dns-record" {
  zone_id = data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTEDZONE_ID
  name    = "${var.COMPONENT}-dev.roboshop.internal"
  type    = "CNAME"
  ttl     = 10
  records = var.ALB_TYPE == ? [data.terraform_remote_state.alb.outputs.PRIVATE_ALB_ADDRESS]
}