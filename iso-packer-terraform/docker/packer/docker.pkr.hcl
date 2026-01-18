source "proxmox-clone" "docker" {
    proxmox_url                 = var.proxmox_api_url
    username                    = var.proxmox_username
    token                       = var.proxmox_token
    insecure_skip_tls_verify    = true
    node                        = var.node
    vm_id                       = var.vm_id
    full_clone                  = true
    clone_vm                    = var.template
    vm_name                     = "docker-template"
    template_description        = "${var.template} Base + Docker, generated on ${timestamp()}"
    tags                        = "docker;${var.template};template"
    ssh_username                = var.vmuser
    cloud_init                  = true
    cloud_init_storage_pool     = var.lvm
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
    "source.proxmox-clone.docker",
  ]
    provisioner "file" {
        source      = "./config/install.sh"
        destination = "/tmp/install.sh"
    }
    provisioner "file" {
        source      = "./config/01_server.sh"
        destination = "/tmp/01_server.sh"
    }
    provisioner "shell" {
        inline = [
            "export DEBIAN_FRONTEND=noninteractive",
            "mkdir -p /scripts",
            "cat /tmp/01_server.sh >> /etc/profile.d/01_server.sh",
            "cat /tmp/install.sh >> /scripts/install.sh",
            "cd /scripts && chmod +x install.sh && ./install.sh"
        ]   
    }
}