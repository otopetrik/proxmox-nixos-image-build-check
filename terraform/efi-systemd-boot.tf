module "testvm_efi-systemd-boot" {
  source         = "./modules/testvm"
  template_id    = var.template_id_efi-systemd-boot
  vm_name        = "test-nixos-efi-systemd-boot"
  network_bridge = var.network_bridge
  datastore_id   = var.datastore_id
  ssh_keys       = var.ssh_keys
}

output "efi-systemd-boot" {
  value = module.testvm_efi-systemd-boot.vm_info
}
