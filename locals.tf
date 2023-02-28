locals {
    ALL_INSTANCE_IDS = concat(aws_spot_instance_request.spot-server.*.spot_instance_id, aws_instance.my-ec2.*.id)
}