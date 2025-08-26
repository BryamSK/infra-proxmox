source "proxmox-iso" "debian12-n1" {
    proxmox_url                 = var.proxmox_api_url
    username                    = var.proxmox_username
    token                       = var.proxmox_token
    insecure_skip_tls_verify    = true
    node                        = var.node1
    vm_id                       = 200
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
    cloud_init_storage_pool     = var.lvm
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
        storage_pool            = var.lvm
        type                    = "scsi"
    }

    boot_command = [
    "<esc><wait>",
    "install auto=true priority=critical ",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "<enter>"
    ]
}

source "proxmox-iso" "debian12-n2" {
    proxmox_url                 = var.proxmox_api_url
    username                    = var.proxmox_username
    token                       = var.proxmox_token
    insecure_skip_tls_verify    = true
    node                        = var.node2
    vm_id                       = 300
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
    cloud_init_storage_pool     = var.lvm
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
        storage_pool            = var.lvm
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
    sources = [
        "source.proxmox-iso.debian12-n1",
        "source.proxmox-iso.debian12-n2",
        ]

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
            "apt install -y cloud-init qemu-guest-agent",
            "mkdir -p /etc/cloud/cloud.cfg.d",
            "cat /tmp/99-custom.cfg >> /etc/cloud/cloud.cfg.d/99-custom.cfg",
            "cat /dev/null > /etc/network/interfaces",
            "echo 'source /etc/network/interfaces.d/*' >> /etc/network/interfaces",
            "apt update -y && apt upgrade -y && apt dist-upgrade -y",
            "cloud-init clean",
        ]   
    }
}