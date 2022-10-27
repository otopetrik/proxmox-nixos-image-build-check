module "testvm_bios-grub-gpt" {
  source         = "./modules/testvm"
  template_id    = var.template_id_bios-grub-gpt
  vm_name        = "test-nixos-bios-grub-gpt"
  network_bridge = var.network_bridge
  datastore_id   = var.datastore_id
  ssh_keys       = var.ssh_keys
}

output "bios-grub-gpt" {
  value = module.testvm_bios-grub-gpt.vm_info
}
