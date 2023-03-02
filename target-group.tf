#  Creates the target group.
resource "aws_lb_target_group" "app-tg" {
  name     = "${var.COMPONENT}-${var.ENV}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID
}

# Attaching the instances to the created target group
resource "aws_lb_target_group_attachment" "instance-attach" {
  target_group_arn = aws_lb_target_group.app-tg.arn
  target_id        = ?
  port             = 80
}