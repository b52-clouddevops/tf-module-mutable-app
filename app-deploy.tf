resource "null_resource" "app" {

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = element(local.ALL_INSTANCE_IPS)  
      }

      inline = [
          "ansible-pull -U https://github.com/b52-clouddevops/ansible.git -e COMPONENT=${var.COMPONENT} -e DB_PASSWORD=RoboShop@1 -e ENV=dev -e APP_VERSION=${var.APP_VERSION} -e ENV=dev robot-pull.yml"
        ]
    }

}