variable "proxmox_api_url" {
  type      = string
  sensitive = true
}
variable "proxmox_username" {
  type      = string
  sensitive = true
}
variable "proxmox_token_id" {
  type      = string
  sensitive = true
}
variable "proxmox_token" {
  type      = string
  sensitive = true
}
variable "storage_pool" {
  description = "Storage pool for VM disks"
  type        = string
}
variable "vm_user" {
  description = "SSH user for cloned template"
  type        = string
}
variable "node" {
  description = "Proxmox node where VMs will be created"
  type        = string
}
variable "template" {
  description = "Name of the template to clone"
  type        = string
}
variable "vm_private_key_path" {
  description = "SSH public key for VM user"
  type        = string
}
variable "memory" {
  description = "memory for the VM"
  type        = string
}
variable "disk_size" {
  description = "disk size for the VM"
  type        = string
}
