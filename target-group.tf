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

# Adding rules to the created target group
resource "aws_lb_listener_rule" "tg-rule" {
  listener_arn = data.terraform_remote_state.alb.outputs.PRIVATE_LISTENER_ARN
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTEDZONE_NAME}"]
    }
  }
}

# Generating random interger in the range of 100 to 800
resource "random_integer" "priority" {
  min = 100
  max = 
  keepers = {
    # Generate a new integer each time we switch to a new listener ARN
    listener_arn = var.listener_arn
  }
}
