module "testvm_bios-hybrid-grub" {
  source         = "./modules/testvm"
  template_id    = var.template_id_bios-hybrid-grub
  vm_name        = "test-nixos-bios-hybrid-grub"
  network_bridge = var.network_bridge
  datastore_id   = var.datastore_id
  ssh_keys       = var.ssh_keys
}

output "bios-hybrid-grub" {
  value = module.testvm_bios-hybrid-grub.vm_info
}
