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
variable "vmuser" {
    type = string
}
variable "vmpass" {
    type = string
    sensitive = true
}

source "proxmox-iso" "k0sdebian12" {
    proxmox_url                 = var.proxmox_api_url
    username                    = var.proxmox_username
    token                       = var.proxmox_token
    insecure_skip_tls_verify    = true
    node                        = "node1"
    ssh_password                = var.vmpass
    ssh_username                = var.vmuser
    template_name               = "k0s-debian12"
    template_description        = "Kubernet Cluster, Debian12, generated on ${timestamp()}"
    cores                       = 2
    cpu_type                    = "x86-64-v2-AES"
    memory                      = 2048
    ssh_timeout                 = "20m"
    http_directory              = "config"

    network_adapters {
      bridge                    = "vmbr0"
      model                     = "virtio"
    }

    boot_iso {
        type                    = "scsi"
        iso_file                = "local:iso/debian12.iso"
        unmount                 = true
    }

    disks {
        disk_size               = "10G"
        storage_pool            = "local-lvm"
        type                    = "scsi"
    }

    boot_command = [
    "<esc><wait>",
    "install auto=true priority=critical ",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "<enter>"
    ]
    boot_wait    = "20s"
}

build {
    sources = ["source.proxmox-iso.k0sdebian12"]
    provisioner "shell-local" {
        inline = [
            "apt update -y",
            "apt install -y git",
        ]
    }
}