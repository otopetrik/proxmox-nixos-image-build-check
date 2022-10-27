module "testvm_bios-grub" {
  source         = "./modules/testvm"
  template_id    = var.template_id_bios-grub
  vm_name        = "test-nixos-bios-grub"
  network_bridge = var.network_bridge
  datastore_id   = var.datastore_id
  ssh_keys       = var.ssh_keys
}

output "bios-grub" {
  value = module.testvm_bios-grub.vm_info
}
