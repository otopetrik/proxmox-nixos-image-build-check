variable "template_id" {
  type = number
}
variable "vm_name" {
  type = string
}
variable "network_bridge" {
  type    = string
  default = "vmbr0"
}
variable "datastore_id" {
  type    = string
  default = "local-zfs"
}
variable "ssh_keys" {
  type = list(string)
}
