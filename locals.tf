locals {
    ALL_INSTANCE_IDS = concat(aws_spot_instance_request.spot-server.*.spot_instance_id, aws_instance.my-ec2.*.id)
    ALL_INSTANCE_IPS = concat(aws_spot_instance_request.spot-server.*.private_ip, aws_instance.my-ec2.*.private_ip)
}