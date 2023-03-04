resource "null_resource" "app" {

  triggers = {
    # version = var.APP_VERSION   #only when there is a change in the value of APP_VERSION compated to previous verion, then only this will be triggered.
      timechange = timestamp()   # Since the time changes all the time, it's going to run all the time.
  }

  count   = var.OD_INSTANCE_COUNT + var.SPOT_INSTANCE_COUNT

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = local.SSH_USER
      password = local.SSH_PASSWORD
      host     = element(local.ALL_INSTANCE_IPS, count.index)  
      }

      inline = [
          "ansible-pull -U https://github.com/b52-clouddevops/ansible.git -e MONGO_URL=${data.terraform_remote_state.db.outputs.MONGO_ENDPOINT} -e COMPONENT=${var.COMPONENT} -e DB_PASSWORD=RoboShop@1 -e ENV=${var.ENV} -e APP_VERSION=${var.APP_VERSION} -e ENV=dev robot-pull.yml"
        ]
    }

}

# By default, provisioners are create-time only; Means they only run during the infrastrucure creation only.