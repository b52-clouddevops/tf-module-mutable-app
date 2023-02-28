resource "null_resource" "app" {

  count   = var.OD_INSTANCE_COUNT + var.SPOT_INSTANCE_COUNT

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = local.SSH_USER
      password = local.SSH_PASSWORD
      host     = element(local.ALL_INSTANCE_IPS, count.index)  
      }

      inline = [
          "ansible-pull -U https://github.com/b52-clouddevops/ansible.git -e COMPONENT=${var.COMPONENT} -e DB_PASSWORD=RoboShop@1 -e ENV=${var.ENV} -e APP_VERSION=${var.APP_VERSION} -e ENV=dev robot-pull.yml"
        ]
    }

}