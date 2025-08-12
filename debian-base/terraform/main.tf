resource "proxmox_vm_qemu" "debian" {
  count           = 1
  name            = "${var.template}-${count.index + 1}"
  target_node     = var.node
  clone           = var.template
  full_clone      = true
  bootdisk        = "scsi0"
  scsihw          = "virtio-scsi-pci"
  ssh_user        = var.vm_user
  ssh_private_key = file(var.vm_private_key_path)
  memory          = 2048
  ipconfig0       = "ip=dhcp"
  agent           = 1

  disk {
    slot    = "scsi0"
    type    = "disk"
    size    = "10G"
    storage = var.storage_pool
  }
  disk {
    slot    = "scsi1"
    type    = "cloudinit"
    storage = var.storage_pool
  }
  network {
    id        = 0
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "virtio"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Provisioned ${self.name}'"
    ]
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = file(var.vm_private_key_path)
      host        = self.ssh_host
    }
  }
}

output "vm_ips" {
  value = [for vm in proxmox_vm_qemu.debian : vm.ssh_host]
}
