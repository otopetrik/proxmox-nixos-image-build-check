variable "template_id_bios-grub" {
  default = "950"
}
variable "template_id_bios-grub-gpt" {
  default = "951"
}
variable "template_id_bios-hybrid-grub" {
  default = "952"
}
variable "template_id_efi-grub" {
  default = "953"
}
variable "template_id_efi-hybrid-grub" {
  default = "954"
}
variable "template_id_efi-systemd-boot" {
  default = "955"
}
variable "network_bridge" {
  default = "vmbr0"
}
variable "datastore_id" {
  default = "local-zfs"
}

variable "proxmox_endpoint" {
  default = "https://proxmox.example.com:8006/"
}

variable "proxmox_insecure" {
  default = true
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_password" {
  type = string
}

variable "ssh_keys" {
  type = list(string)
}

