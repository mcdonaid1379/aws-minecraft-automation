
variable "aws_region" {
description = "The AWS region to deploy resources in."
type        = string
default     = "us-east-1"
}

variable "instance_type" {
description = "The EC2 instance type for the Minecraft server."
type        = string
default     = "t3.small"
}

variable "key_name" {
description = "The name for the EC2 Key Pair."
type        = string
default     = "minecraft-key"
}

variable "public_key_path" {
description = "The file path to your public SSH key."
type        = string
default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
description = "The file path to your private SSH key for Ansible."
type        = string
default     = "~/.ssh/id_rsa"
}

