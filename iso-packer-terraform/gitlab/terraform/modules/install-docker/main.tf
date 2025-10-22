resource "null_resource" "install_docker" {
  provisioner "file" {
    source      = "./modules/install-docker/config/install-docker.sh"
    destination = "/tmp/install-docker.sh"
    connection {
      type        = "ssh"
      host        = var.host
      user        = var.user
      private_key = file(var.private_key_path)
    }
  }
  provisioner "file" {
    source      = "./modules/install-docker/config/01_server.sh"
    destination = "/tmp/01_server.sh"
    connection {
      type        = "ssh"
      host        = var.host
      user        = var.user
      private_key = file(var.private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "touch /etc/profile.d/01_server.sh && cat /tmp/01_server.sh >> /etc/profile.d/01_server.sh",
      "chmod +x /etc/profile.d/01_server.sh",
      "chmod +x /tmp/install-docker.sh",
      "bash /tmp/install-docker.sh",
      "rm /tmp/install-docker.sh",
      "rm /tmp/01_server.sh"
    ]
    connection {
      type        = "ssh"
      host        = var.host
      user        = var.user
      private_key = file(var.private_key_path)
    }
  }
}