resource "aws_route53_record" "component" {
  zone_id = "Z090521761DHPU3HXLNP"
  name    = "${var.COMPONENT}-dev.roboshop.internal"
  type    = "CNAME"
  ttl     = 10
  records = [data.]
}