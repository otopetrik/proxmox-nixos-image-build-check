terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.6.4"
    }
  }
}

provider "proxmox" {
  virtual_environment {
    endpoint = var.proxmox_endpoint
    username = var.proxmox_username
    password = var.proxmox_password
    insecure = var.proxmox_insecure
  }
}
