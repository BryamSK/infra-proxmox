variable "storage_pool" {
  description = "Storage pool for VM disks"
  type        = string
}
variable "vm_user" {
  description = "SSH user for cloned template"
  type        = string
}
variable "vm_private_key_path" {
  description = "Path to private SSH key for provisioning"
  type        = string
}
variable "node" {
  description = "Proxmox node where VMs will be created"
  type        = string
}

resource "proxmox_vm_qemu" "k0s_node" {
  count       = 2
  name        = "k0s-node-${count.index + 1}"
  target_node = var.node
  clone       = "k0s-debian12"
  full_clone  = true
  bootdisk    = "scsi0"
  scsihw      = "virtio-scsi-pci"

  disk {
    slot    = "scsi0"
    type    = "disk"
    storage = var.storage_pool
    size    = "10G"
  }
  network {
    id        = 0
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "virtio"
  }

  ipconfig0       = "ip=dhcp"
  ssh_user        = var.vm_user
  ssh_private_key = file(var.vm_private_key_path)

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

resource "proxmox_vm_qemu" "k0s_master" {
  count       = 1
  name        = "k0s-master-${count.index + 1}"
  target_node = var.node
  clone       = "k0s-debian12"
  full_clone  = true
  bootdisk    = "scsi0"
  scsihw      = "virtio-scsi-pci"

  disk {
    slot    = "scsi0"
    type    = "disk"
    storage = var.storage_pool
    size    = "10G"
  }
  network {
    id        = 0
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "virtio"
  }

  ipconfig0       = "ip=dhcp"
  ssh_user        = var.vm_user
  ssh_private_key = file(var.vm_private_key_path)

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