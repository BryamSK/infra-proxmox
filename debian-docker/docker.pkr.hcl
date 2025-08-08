packer {
  required_plugins {
    proxmox = {
      version = ">= 1.2.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_api_url" {
    type = string
    sensitive = true
}
variable "proxmox_username" {
    type = string
    sensitive = true
}
variable "proxmox_token" {
    type = string
    sensitive = true
}
variable "node" {
    type = string
}
variable "vm_id" {
    type = number
}
variable "vmuser" {
    type = string
}
variable "vmpass" {
    type = string
    sensitive = true
}

source "proxmox-clone" "docker" {
    proxmox_url                 = var.proxmox_api_url
    username                    = var.proxmox_username
    token                       = var.proxmox_token
    insecure_skip_tls_verify    = true
    node                        = var.node
    full_clone                  = true
    clone_vm                    = "debian12"
    vm_name                     = "docker"
    vm_id                       = var.vm_id
    template_description        = "Debian12 Base + Docker, generated on ${timestamp()}"
    tags                        = "docker;debian12;template"
    ssh_username                = var.vmuser
    cloud_init                  = true
    cloud_init_storage_pool     = "local-lvm"
    cloud_init_disk_type        = "scsi"
    qemu_agent                  = true
    task_timeout                = "10m"

    ipconfig {
        ip                      = "dhcp"
    }
    network_adapters {
        bridge                  = "vmbr0"
        model                   = "virtio"
    }
}

build {
  sources = ["source.proxmox-clone.docker"]
    provisioner "file" {
        source      = "./config/install.sh"
        destination = "/tmp/install.sh"
    }
    provisioner "shell" {
        inline = [
            "export DEBIAN_FRONTEND=noninteractive",
            "mkdir -p /scripts",
            "cat /tmp/install.sh >> /scripts/install.sh",
            "cd /scripts && chmod +x install.sh && ./install.sh"
        ]   
    }
}