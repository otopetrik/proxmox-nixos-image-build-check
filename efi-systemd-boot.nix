{ pkgs, self, ... }: {
  proxmox = { qemuConf = { bios = "ovmf"; }; };
  boot.loader.systemd-boot.enable = true;
  system.nixos.tags = [ "efi-systemd-boot" ];
}
