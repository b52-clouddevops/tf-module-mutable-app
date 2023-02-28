# Creates on-demand servers

# creates ec2 instance
resource "aws_instance" "my-ec2" {
  count                   = var.OD_INSTANCE_COUNT
  ami                     = data.aws_ami.lab-image.id
  instance_type           = var.INSTANCE_TYPE
  subnet_id               = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS, count.index)
  vpc_security_group_ids  = [aws_security_group.allow_app.id]

  tags = {
      Name = "${var.COMPONENT}-${var.ENV}"
  }
}


# Creates SPOT Servers
resource "aws_spot_instance_request" "cheap_worker" {
  count                = var.SPOT_INSTANCE_COUNT
  ami                  = data.aws_ami.lab-image.id
  instance_type        = var.INSTANCE_TYPE
  wait_for_fulfillment = true

  tags = {
    Name = "${var.COMPONENT}-${var.ENV}"
  }
}