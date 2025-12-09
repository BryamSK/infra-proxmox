variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
  sensitive   = true
}
variable "proxmox_username" {
  description = "value for Proxmox username"
  type        = string
  sensitive   = true
}
variable "proxmox_token_id" {
  description = "Proxmox API token ID"
  type        = string
  sensitive   = true
}
variable "proxmox_token" {
  description = "Proxmox API token value"
  type        = string
  sensitive   = true
}
variable "storage_pool" {
  description = "Storage pool for VM disks"
  type        = string
}
variable "vmid" {
  description = "VM ID for the container"
  type        = number
}
variable "password" {
  description = "Password for the VM user"
  type        = string
  sensitive   = true
}
variable "user" {
  description = "SSH user for cloned template"
  type        = string
}
variable "node" {
  description = "Proxmox node where VMs will be created"
  type        = string
}
variable "template_name" {
  description = "Name of the template to clone"
  type        = string
}
variable "public_key_path" {
  description = "SSH public key for VM user"
  type        = string
  sensitive   = true
}
variable "private_key_path" {
  description = "SSH private key for VM user"
  type        = string
  sensitive   = true
}
variable "memory" {
  description = "SSH public key for VM user"
  type        = string
}
variable "disk_size" {
  description = "SSH public key for VM user"
  type        = string
}
variable "arch" {
  description = "Architecture for the VM"
  type        = string
}
variable "cores" {
  description = "Number of CPU cores for the VM"
  type        = number
}
variable "cpulimit" {
  description = "CPU limit for the VM"
  type        = number
}
variable "swap" {
  description = "Swap for the VM"
  type        = number
}
variable "onboot" {
  description = "Whether to start the container on boot"
  type        = bool
}
variable "start" {
  description = "Whether to start the container after creation"
  type        = bool
}
variable "template_path" {
  description = "LXC template to use for the container"
  type        = string
}
variable "ip" {
  description = "IP configuration for eth0"
  type        = string
}
variable "gw" {
  description = "Gateway for eth0"
  type        = string
}
variable "tags" {
  description = "Tags to apply to the LXC container"
  type        = string
}
variable "name" {
  description = "Hostname"
  type        = string
}
variable "description" {
  description = "Description for the LXC container"
  type        = string
}
