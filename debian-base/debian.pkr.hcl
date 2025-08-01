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

source "proxmox-iso" "debian12" {
    proxmox_url                 = var.proxmox_api_url
    username                    = var.proxmox_username
    token                       = var.proxmox_token
    insecure_skip_tls_verify    = true
    node                        = var.node
    vm_id                       = var.vm_id
    ssh_password                = var.vmpass
    ssh_username                = var.vmuser
    template_name               = "debian12"
    template_description        = "Debian12 Base, generated on ${timestamp()}"
    tags                        = "debian12;template"
    cores                       = 4
    cpu_type                    = "kvm64"
    memory                      = 4096
    ssh_timeout                 = "20m"
    http_directory              = "config"
    cloud_init                  = true
    cloud_init_storage_pool     = "local-lvm"
    cloud_init_disk_type        = "scsi"
    qemu_agent                  = true
    boot_wait                   = "20s"      

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
}

build {
    sources = ["source.proxmox-iso.debian12"]

    provisioner "file" {
        source      = "/root/.ssh/id_rsa.pub"
        destination = "/tmp/id_rsa.pub"
    }
    provisioner "file" {
        source      = "./config/99-custom.cfg"
        destination = "/tmp/99-custom.cfg"
    }
    provisioner "shell" {
        inline = [
            "mkdir -p /root/.ssh",
            "chmod 700 /root/.ssh",
            "cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys",
            "chmod 600 /root/.ssh/authorized_keys",
            "chown root:root /root/.ssh/authorized_keys",
            "export DEBIAN_FRONTEND=noninteractive",
            "mkdir -p /etc/cloud/cloud.cfg.d",
            "cat /tmp/99-custom.cfg >> /etc/cloud/cloud.cfg.d/99-custom.cfg",
            "cat /dev/null > /etc/network/interfaces",
            "echo 'source /etc/network/interfaces.d/*' >> /etc/network/interfaces",
            "apt update -y && apt upgrade -y && apt dist-upgrade -y"
            "cloud-init clean",
        ]   
    }
}