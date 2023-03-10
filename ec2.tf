# Creates on-demand servers

resource "aws_instance" "my-ec2" {
  count                   = var.OD_INSTANCE_COUNT
  ami                     = data.aws_ami.lab-image.id
  instance_type           = var.INSTANCE_TYPE
  subnet_id               = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS, count.index)
  vpc_security_group_ids  = [aws_security_group.allow_app.id]
  iam_instance_profile    = "b52-admin-role"
}


# Creates SPOT Servers
resource "aws_spot_instance_request" "spot-server" {
  count                   = var.SPOT_INSTANCE_COUNT
  ami                     = data.aws_ami.lab-image.id
  instance_type           = var.INSTANCE_TYPE
  subnet_id               = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS, count.index)
  vpc_security_group_ids  = [aws_security_group.allow_app.id]
  wait_for_fulfillment    = true
  iam_instance_profile    = "b52-admin-role"

  tags = {
    Name = "${var.COMPONENT}-${var.ENV}"
  }
}

# Creates the tags to spot instance 

resource "aws_ec2_tag" "spot-server-tag" {
  count       = var.SPOT_INSTANCE_COUNT + var.OD_INSTANCE_COUNT
  resource_id = element(local.ALL_INSTANCE_IDS, count.index)
  key         = "Name"
  value       = "${var.COMPONENT}-${var.ENV}"
}

resource "aws_ec2_tag" "env-tag" {
  count       = var.SPOT_INSTANCE_COUNT + var.OD_INSTANCE_COUNT
  resource_id = element(local.ALL_INSTANCE_IDS, count.index)
  key         = "ENV"
  value       = var.ENV
}

resource "aws_ec2_tag" "prometheus-monitor" {
  count       = var.SPOT_INSTANCE_COUNT + var.OD_INSTANCE_COUNT
  resource_id = element(local.ALL_INSTANCE_IDS, count.index)
  key         = "prometheus-monitor"
  value       = "yes"
}