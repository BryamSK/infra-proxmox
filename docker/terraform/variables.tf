
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
variable "vm_private_key_path" {
  description = "Path to private SSH key for provisioning"
  type        = string
}
variable "node1" {
  description = "Proxmox node where VMs will be created"
  type        = string
}
variable "node2" {
  description = "Proxmox node where VMs will be created"
  type        = string
}
variable "template" {
  description = "Proxmox node where VMs will be created"
  type        = string
}
