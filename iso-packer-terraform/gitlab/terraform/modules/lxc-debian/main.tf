resource "proxmox_lxc" "debian" {
  count           = 1
  hostname        = "lxc-${var.template_name}-${count.index + 1}"
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
  
  provisioner "remote-exec" {
    inline = [
      "echo 'Provisioned ${self.hostname}'"
    ]
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = file(var.private_key_path)
      host        = var.ip
    }
  }
}