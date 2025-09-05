provider "aws" {
  region = var.region
}

resource "aws_instance" "jenkins" {
  ami           = var.ami
  instance_type = "t2.medium"
  key_name      = var.key_name
  tags = {
    Name = "Jenkins-Server"
  }
}
