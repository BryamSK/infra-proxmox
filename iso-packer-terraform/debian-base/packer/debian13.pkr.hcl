source "proxmox-iso" "debian13" {
    proxmox_url                 = var.proxmox_api_url
    username                    = var.proxmox_username
    token                       = var.proxmox_token
    insecure_skip_tls_verify    = true
    node                        = var.node1
    vm_id                       = 913
    ssh_password                = var.vmpass
    ssh_username                = var.vmuser
    template_name               = "debian13-template"
    template_description        = "Debian13 Base, generated on ${timestamp()}"
    tags                        = "debian13;template"
    sockets                     = 1
    cores                       = 4
    cpu_type                    = "kvm64"
    memory                      = 8192
    ssh_timeout                 = var.timeout
    http_directory              = "config"
    cloud_init                  = true
    cloud_init_storage_pool     = var.lvm
    cloud_init_disk_type        = "ide"
    qemu_agent                  = true
    boot_wait                   = "20s"
  
    network_adapters {
      bridge                    = "vmbr0"
      model                     = "virtio"
    }
    boot_iso {
        type                    = "scsi"
        iso_file                = "${var.isopath}debian13.iso"
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
        "source.proxmox-iso.debian13",
        ]

    provisioner "file" {
        source      = var.sshkey
        destination = "/tmp/id_rsa.pub"
    }
    provisioner "file" {
        source      = "./config/99-custom.cfg"
        destination = "/tmp/99-custom.cfg"
    }
    provisioner "file" {
        source      = "./config/10_debian.sh"
        destination = "/tmp/10_debian.sh"
    }
    provisioner "file" {
        source      = "./config/init.sh"
        destination = "/tmp/init.sh"
    }
    provisioner "shell" {
        inline = [
           "cp /tmp/init.sh .",
            "chmod +x init.sh",
            "./init.sh",
        ]   
    }
}