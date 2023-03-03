#  Creates the target group.
resource "aws_lb_target_group" "app-tg" {
  name     = "${var.COMPONENT}-${var.ENV}"
  port     = var.APP_PORT
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID

  health_check {
    path = "/health"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 4
    interval = 5

  }

}

# Attaching the instances to the created target group
resource "aws_lb_target_group_attachment" "instance-attach" {
  count            = var.SPOT_INSTANCE_COUNT + var.OD_INSTANCE_COUNT
  target_group_arn = aws_lb_target_group.app-tg.arn
  target_id        =  element(local.ALL_INSTANCE_IDS, count.index)
  port             = var.APP_PORT
}


# Backend components  target groups apart from frontend-tg has to go and be attached to Private Load Balancer Only
# Frontend Component target groups should go and attach to Public Load Balancer Only

# Generating random interger in the range of 100 to 800
resource "random_integer" "priority" {
  min = 100
  max = 800
}


# Adding rules to the created public target group
resource "aws_lb_listener_rule" "private-tg-rule" {
  count        = var.ALB_TYPE == "internal" ? 1 : 0

  listener_arn = data.terraform_remote_state.alb.outputs.PRIVATE_LISTENER_ARN
  priority     = random_integer.priority.result

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



# Creating a listener in the public load-balancer
resource "aws_lb_listener" "public" {
  count             = var.ALB_TYPE == "internal" ? 0 : 1

  load_balancer_arn = data.terraform_remote_state.alb.outputs.PUBLIC_ALB_ARN
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}