{ pkgs, self, ... }: {
  proxmox = { qemuConf = { bios = "ovmf"; }; };
  system.nixos.tags = [ "efi-grub" ];
}
