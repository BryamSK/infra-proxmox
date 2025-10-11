variable "proxmox_api_url" {
    description = "Proxmox API URL"
    type        = string
    sensitive   = true
}
variable "proxmox_username" {
    description = "Proxmox API username"
    type        = string
    sensitive   = true
}
variable "proxmox_token" {
    description = "Proxmox API token"
    type        = string
    sensitive   = true
}
variable "node1" {
    description = "First Proxmox node name"
    type = string
}
variable "node2" {
    description = "Second Proxmox node name"
    type = string
}
variable "vmuser" {
    description = "Username for the VM"
    type        = string
}
variable "vmpass" {
    description = "Password for the VM user"
    type        = string
    sensitive   = true
}
variable "lvm" {
    description = "LVM storage pool for VM disks"
    type        = string
    sensitive   = true
}
variable "isopath" {
    description = "LVM storage pool for VM disks"
    type        = string
    sensitive   = true
}
variable "sshkey" {
    description = "SSH public key for VM user"
    type        = string
    sensitive   = true
}
variable "timeout" {
    description = "SSH timeout for VM"
    type        = string
    sensitive   = true
}