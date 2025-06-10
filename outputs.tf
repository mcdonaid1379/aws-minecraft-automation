output "minecraft_server_public_ip" {
  description = "The public IP address of the Minecraft server."
  value       = aws_instance.minecraft_server.public_ip
}