output "vm_ips" {
  value = [for vm in proxmox_vm_qemu.k0s_node : vm.ssh_host]
}