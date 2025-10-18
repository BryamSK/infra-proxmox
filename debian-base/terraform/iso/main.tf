module "debian_vm" {
  source = "../modules/iso"

    proxmox_api_url         = var.proxmox_api_url
    proxmox_username        = var.proxmox_username
    proxmox_token_id        = var.proxmox_token_id
    proxmox_token           = var.proxmox_token
    storage_pool            = var.storage_pool
    vm_user                 = var.vm_user
    vm_private_key_path     = var.vm_private_key_path
    node                    = var.node1
    template                = var.template
    memory                  = var.memory
    disk_size               = var.disk_size
}