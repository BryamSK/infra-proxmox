output "vm_ips" {
  description = "IPs de las VMs creadas"
  value       = [for vm in proxmox_vm_qemu.debian : vm.ssh_host]
}

output "vm_names" {
  description = "Nombres de las VMs creadas"
  value       = [for vm in proxmox_vm_qemu.debian : vm.name]
}