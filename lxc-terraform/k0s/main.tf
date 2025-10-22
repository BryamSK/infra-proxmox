module "debian-base" {
source = "./../modules/debian-base"

    proxmox_api_url         = var.proxmox_api_url
    proxmox_username        = var.proxmox_username
    proxmox_token_id        = var.proxmox_token_id
    proxmox_token           = var.proxmox_token
    storage_pool            = var.storage_pool
    vmid                    = var.vmid
    password                = var.password
    user                    = var.user
    node                    = var.node
    template_name           = var.template_name
    template_path           = var.template_path
    public_key_path         = var.public_key_path
    private_key_path        = var.private_key_path
    memory                  = var.memory
    disk_size               = var.disk_size
    arch                    = var.arch
    cores                   = var.cores
    cpulimit                = var.cpulimit
    swap                    = var.swap
    onboot                  = var.onboot
    start                   = var.start
    ip                      = var.ip
    gw                      = var.gw
    tags                    = var.tags
    host                    = var.ip
    name                    = var.name
}

module "install_k0s" {
  source = "./../modules/install_k0s"
    user                  = var.user
    private_key_path      = var.private_key_path
    host                  = var.ip
    name                  = var.name
    depends_on = [module.debian-base]
}

resource "null_resource" "get_kubeconfig" {
  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ${var.private_key_path} root@${var.ip}:/root/kubeconfig ./kubeconfig-${var.name}-${var.ip}"
  }
  depends_on = [module.install_k0s]
}

resource "null_resource" "merge_kubeconfigs" {
  provisioner "local-exec" {
    command = "export KUBECONFIG=$(find . -name 'kubeconfig-*' | paste -sd :) && kubectl config view --flatten > ~/.kube/config"
  }
  depends_on = [null_resource.get_kubeconfig]
}