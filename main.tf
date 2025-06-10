
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-server-sg"
  description = "Allow SSH and Minecraft server traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Minecraft_SG"
  }
}

resource "aws_key_pair" "minecraft_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "minecraft_server" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = var.instance_type
  key_name      = aws_key_pair.minecraft_key.key_name
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  tags = {
    Name = "Minecraft_Server"
  }
  
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = <<-EOT
      ansible-playbook -i "${self.public_ip}," \
      --user ubuntu \
      --private-key ${var.private_key_path} \
      --ssh-common-args '-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' \
      ansible/playbook.yml
    EOT
  }
}