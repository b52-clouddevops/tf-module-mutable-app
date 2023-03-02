#  Creates the target group.

resource "aws_lb_target_group" "app-tg" {
  name     = "${var.COMPONENT}-${dev}
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}
