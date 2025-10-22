resource "null_resource" "install_docker" {
  provisioner "file" {
    source      = "./../modules/install-docker/config/20_docker.sh"
    destination = "/etc/profile.d/20_docker.sh"
    connection {
      type        = "ssh"
      host        = var.host
      user        = var.user
      private_key = file(var.private_key_path)
    }
  }

  provisioner "file" {
    source      = "./../modules/install-docker/config/install-docker.sh"
    destination = "/tmp/install-docker.sh"
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
      "chmod +x /etc/profile.d/20_docker.sh",
      "chmod +x /tmp/install-docker.sh",
      "bash /tmp/install-docker.sh",
      "rm /tmp/install-docker.sh",
    ]
    connection {
      type        = "ssh"
      host        = var.host
      user        = var.user
      private_key = file(var.private_key_path)
    }
  }
}