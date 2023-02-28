resource "null_resource" "app" {
    
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = self.public_ip         # self. will only work if it's inside the resource ; If not, we need to use aws_instance.my-ec2.public_ip
      }

      inline = [
          "ansible-pull -U https://github.com/b52-clouddevops/ansible.git -e COMPONENT=${var.COMPONENT} -e DB_PASSWORD=RoboShop@1 -e ENV=dev -e APP_VERSION=${var.APP_VERSION} -e ENV=dev robot-pull.yml"
        ]
    }

}