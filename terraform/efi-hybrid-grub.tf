module "testvm_efi-hybrid-grub" {
  source         = "./modules/testvm"
  template_id    = var.template_id_efi-hybrid-grub
  vm_name        = "test-nixos-efi-hybrid-grub"
  network_bridge = var.network_bridge
  datastore_id   = var.datastore_id
  ssh_keys       = var.ssh_keys
}

output "efi-hybrid-grub" {
  value = module.testvm_efi-hybrid-grub.vm_info
}
