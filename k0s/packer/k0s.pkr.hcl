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
    cores                       = 1
    cpu_type                    = "x86-64-v2-AES"
    memory                      = 1024
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
    provisioner "shell" {
      inline = [
          "apt update -y",
          "apt install -y cloud-init qemu-guest-agent sudo curl git",
          "systemctl enable qemu-guest-agent",
          "systemctl start qemu-guest-agent",
          "echo 'datasource_list: [ NoCloud, ConfigDrive ]' > /etc/cloud/cloud.cfg.d/90_dpkg.cfg",
          "echo 'disable_root: false' >> /etc/cloud/cloud.cfg",
          "echo 'preserve_hostname: true' >> /etc/cloud/cloud.cfg",
          "cloud-init clean"
          ]
      }
    provisioner "shell-local" {
        inline = [
            # "apt update -y",
            # "apt upgrade -y",
            # "apt install -y git curl",
            "curl --proto '=https' --tlsv1.2 -sSf https://get.k0s.sh | sh"
        ]
    }
    provisioner "file" {
        source      = "/root/.ssh/id_rsa.pub"
        destination = "/tmp/id_rsa.pub"
    }
    provisioner "shell" {
        inline = [
            "mkdir -p /root/.ssh",
            "chmod 700 /root/.ssh",
            "cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys",
            "chmod 600 /root/.ssh/authorized_keys",
            "chown root:root /root/.ssh/authorized_keys"
        ]   
    }
}