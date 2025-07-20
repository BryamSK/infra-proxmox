terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc03"
    }
  }
}

variable "proxmox_api_url" {
    type = string
    sensitive = true
}
variable "proxmox_username" {
    type = string
    sensitive = true
}
variable "proxmox_token" {
    type = string
    sensitive = true
}

provider "proxmox" {
    pm_api_url          = var.proxmox_api_url
    pm_user             = var.proxmox_username
    pm_api_token_id     = var.proxmox_token
    pm_tls_insecure     = true
}