terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc03"
    }
  }
}

variable "proxmox_api_url" {
  type      = string
  sensitive = true
}
variable "proxmox_username" {
  type      = string
  sensitive = true
}
variable "proxmox_token_id" {
  type      = string
  sensitive = true
}
variable "proxmox_token" {
  type      = string
  sensitive = true
}
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

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_user             = var.proxmox_username
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "docker" {
  count           = 1
  name            = "docker-${count.index + 1}"
  target_node     = var.node
  clone           = "docker"
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
  value = [for vm in proxmox_vm_qemu.docker : vm.ssh_host]
}
