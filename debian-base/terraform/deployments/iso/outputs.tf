output "vm_ips" {
  description = "IP de los VMs creados"
  value       = module.debian_vm.vm_ips
}

output "vm_names" {
  description = "Nombres de los VMs creados"
  value       = module.debian_vm.vm_names
}