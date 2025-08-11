variable "proxmox_api_url" {
    type        = string
    sensitive   = true
}

variable "proxmox_username" {
    type        = string
    sensitive   = true
}

variable "proxmox_token" {
    type        = string
    sensitive   = true
}

variable "node" {
    type        = string
}

variable "vm_id" {
    type        = number
}

variable "vmuser" {
    type        = string
}

variable "vmpass" {
    type        = string
    sensitive   = true
}

variable "lvm" {
    type        = string
    sensitive   = true
}