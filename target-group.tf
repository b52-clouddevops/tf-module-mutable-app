#  Creates the target group.
resource "aws_lb_target_group" "app-tg" {
  name     = "${var.COMPONENT}-${var.ENV}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID
}

# Attaching the instances to the created target group
resource "aws_lb_target_group_attachment" "instance-attach" {
  count            = var.SPOT_INSTANCE_COUNT + var.OD_INSTANCE_COUNT
  target_group_arn = aws_lb_target_group.app-tg.arn
  target_id        =  element(local.ALL_INSTANCE_IDS, count.index)
  port             = 8080
}


# Backend components  target groups apart from frontend-tg has to go and be attached to Private Load Balancer Only
# Frontend Component target groups should go and attach to Public Load Balancer Only

