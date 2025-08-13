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
variable "node1" {
    type = string
}
variable "node2" {
    type = string
}
variable "vm_n1_id" {
    type = number
}
variable "vm_n2_id" {
    type = number
}
variable "vmuser" {
    type = string
}
variable "vmpass" {
    type = string
    sensitive = true
}
variable "template" {
    type = string
    sensitive = true
}

source "proxmox-clone" "k0s_n1" {
    proxmox_url                 = var.proxmox_api_url
    username                    = var.proxmox_username
    token                       = var.proxmox_token
    insecure_skip_tls_verify    = true
    node                        = var.node1
    vm_id                       = var.vm_n1_id
    full_clone                  = true
    clone_vm                    = var.template
    vm_name                     = "k0s"
    template_description        = "${var.template} Base + k0s, generated on ${timestamp()}"
    tags                        = "k0s;${var.template};template"
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

source "proxmox-clone" "k0s_n2" {
    proxmox_url                 = var.proxmox_api_url
    username                    = var.proxmox_username
    token                       = var.proxmox_token
    insecure_skip_tls_verify    = true
    node                        = var.node2
    vm_id                       = var.vm_n2_id
    full_clone                  = true
    clone_vm                    = var.template
    vm_name                     = "k0s"
    template_description        = "${var.template} Base + k0s, generated on ${timestamp()}"
    tags                        = "k0s;${var.template};template"
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
  sources = [
    "source.proxmox-clone.k0s_n1",
    "source.proxmox-clone.k0s_n2",
    ]
    provisioner "shell" {
        inline = [
            "export DEBIAN_FRONTEND=noninteractive",
            "apt update -y && apt upgrade -y && apt dist-upgrade -y",
            "apt install -y curl",
            "curl --proto '=https' --tlsv1.2 -sSf https://get.k0s.sh | sh",
        ]   
    }
}