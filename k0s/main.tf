###Cluster K0s on Proxmox
# This Terraform configuration deploys a k0s cluster on Proxmox using a Debian template
resource "proxmox_vm_qemu" "k0s_single" {
  count = 1
  name  = "k0s-single-${count.index + 1}"
  target_nodes    = var.nodes
  clone           = "k0s"
  full_clone      = true
  bootdisk        = "scsi0"
  scsihw          = "virtio-scsi-pci"
  ssh_user        = var.vm_user
  ssh_private_key = file(var.vm_private_key_path)
  memory          = 1024
  agent           = 1
  os_type         = "cloud-init"
  ipconfig0       = "gw=192.168.99.1,ip=${element(var.ips_nodes, count.index)}/24"

  cpu {
    cores = 1
  }
  disk {
    slot    = "scsi0"
    type    = "disk"
    storage = var.storage_pool
    size    = "10G"
  }
  disk {
    slot    = "scsi2"
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
      "k0s install controller --single",
      "systemctl daemon-reload",
      "systemctl enable k0scontroller",
      "systemctl start k0scontroller",
      "sleep 20",
      "k0s kubeconfig admin > kubeconfig",
    ]
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = file(var.vm_private_key_path)
      host        = self.ssh_host
    }
  }
}

output "vm_ip_single" {
  value = [for vm in proxmox_vm_qemu.k0s_single : vm.ssh_host]
}


resource "null_resource" "wait_for_ssh" {
  provisioner "remote-exec" {
    inline = ["echo 'SSH is ready'"]
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = file(var.vm_private_key_path)
      host        = proxmox_vm_qemu.k0s_single[0].ssh_host
    }
  }

  depends_on = [proxmox_vm_qemu.k0s_single]
}

resource "null_resource" "get_kubeconfig" {
  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ${var.vm_private_key_path} root@${proxmox_vm_qemu.k0s_single[0].ssh_host}:/root/kubeconfig ./kubeconfig-${proxmox_vm_qemu.k0s_single[0].name}"
  }

  depends_on = [null_resource.wait_for_ssh, proxmox_vm_qemu.k0s_single]
}

resource "null_resource" "merge_kubeconfigs" {
  provisioner "local-exec" {
    command = "export KUBECONFIG=$(find . -name 'kubeconfig-*' | paste -sd :) && kubectl config view --flatten > ~/.kube/config"
  }
    depends_on = [null_resource.get_kubeconfig]
}
