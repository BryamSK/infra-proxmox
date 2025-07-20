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
    sensitive = true
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
    ssh_timeout                 = "10m"
    ssh_password                = var.vmpass
    ssh_username                = var.vmuser
    template_description        = "Kubernet Cluster, Devian12, generated on ${timestamp()}"
    cores                       = 2
    cpu_type                    = "x86-64-v2-AES"
    memory                      = 2048
    
    network_adapters {
      bridge                    = "vmbr0"
      model                     = "virtio"
      firewall                  = true
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
#   "debian-installer=es_ES auto locale=es_ES ",
#   "kbd-chooser/method=es ",
#   "keyboard-configuration/layout=es ",
#   "keyboard-configuration/variant=es ",
#   "hostname=k0s ",
#   "fb=false debconf/frontend=noninteractive ",
  "<enter>"
  ]
  boot_wait    = "20s"
}

build {
    sources = ["source.proxmox-iso.k0sdebian12"]

    provisioner "ansible" {
      playbook_file = "ansible/playbook.yml"
    }
}