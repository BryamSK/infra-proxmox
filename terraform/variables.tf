variable "proxmox_url" {
  type = string
}

variable "proxmox_token" {
  type = string
  sensitive = true
}

variable "template_name" {
  type = string
}
