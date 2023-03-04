# Fetches the information of the remote statefile, here in our case, this will fetch the information of the VPC Statefile
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
        bucket = "b52-terraform-state-bucket"
        key    = "vpc/${var.ENV}/terraform.tfstate"
        region = "us-east-1"
  }
}

# This is to read the information from the tf alb backend module
data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
        bucket = "b52-terraform-state-bucket"
        key    = "alb/${var.ENV}/terraform.tfstate"
        region = "us-east-1"
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
        bucket = "b52-terraform-state-bucket"
        key    = "databases/${var.ENV}/terraform.tfstate"
        region = "us-east-1"
  }
}

# This is to read the information of the AMI
data "aws_ami" "lab-image" {
  most_recent      = true
  name_regex       = "b52-ansible-dev-20Jan2023"
  owners           = ["self"]
}



# fetching the metadata of the secret
data "aws_secretsmanager_secret" "secrets" {
  name = "robotshop/secrets"
}

data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}
