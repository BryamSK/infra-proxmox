output "lxc_info" {
  description = "Información completa del contenedor LXC creado"
  value = [
    for lxc in proxmox_lxc.debian: {
      id            = lxc.id
      vmid          = lxc.vmid
      hostname      = lxc.hostname
      description   = lxc.description
      ip_addresses  = lxc.network[0].ip
      target_node   = lxc.target_node
    }
  ]
}