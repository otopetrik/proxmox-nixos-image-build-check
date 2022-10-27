module "testvm_efi-grub" {
  source         = "./modules/testvm"
  template_id    = var.template_id_efi-grub
  vm_name        = "test-nixos-efi-grub"
  network_bridge = var.network_bridge
  datastore_id   = var.datastore_id
  ssh_keys       = var.ssh_keys
}

output "efi-grub" {
  value = module.testvm_efi-grub.vm_info
}
