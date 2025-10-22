resource "proxmox_lxc" "debian" {
  count           = 1
  hostname        = var.name
  vmid            = var.vmid + count.index
  target_node     = var.node
  ostemplate      = var.template_path
  arch            = var.arch
  cores           = var.cores
  cpulimit        = var.cpulimit
  memory          = var.memory
  swap            = var.swap
  ostype          = var.template_name
  description     = "LXC container for ${var.template_name}"
  onboot          = var.onboot
  start           = var.start
  password        = var.password
  tags            = var.tags

  rootfs {
    storage = var.storage_pool
    size    = var.disk_size
  }
  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${var.ip}/24,gw=${var.gw}"
  }

  ssh_public_keys = file(var.public_key_path)
}

resource "null_resource" "debian" {
  provisioner "file" {
    source      = "./../modules/debian-base/config/10_debian.sh"
    destination = "/etc/profile.d/10_debian.sh"
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
      "chmod +x /etc/profile.d/10_debian.sh",
      "apt update && apt upgrade -y && apt dist-upgrade -y && apt autoremove -y && apt clean"
    ]
    connection {
      type        = "ssh"
      host        = var.host
      user        = var.user
      private_key = file(var.private_key_path)
    }
  }
}  
