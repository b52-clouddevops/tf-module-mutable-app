resource "aws_route53_record" "dns-record" {
  zone_id = var.ALB_TYPE == "internal" ? data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTEDZONE_ID : data.terraform_remote_state.vpc.outputs.PUBLIC_HOSTEDZONE_ID 
  name    = var.ALB_TYPE == "internal" ? "${var.COMPONENT}-dev.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTEDZONE_NAME}" : "${var.COMPONENT}-dev.${data.terraform_remote_state.vpc.outputs.PUBLIC_HOSTEDZONE_NAME}"
  type    = "CNAME"
  ttl     = 10
  records = var.ALB_TYPE == "internal" ? [data.terraform_remote_state.alb.outputs.PRIVATE_ALB_ADDRESS] : [data.terraform_remote_state.alb.outputs.PUBLIC_ALB_ADDRESS]
}