{ pkgs, self, ... }: {
  proxmox = {
    qemuConf = { bios = "ovmf"; };
    partitionTableType = "hybrid";
  };
  system.nixos.tags = [ "efi-hybrid-grub" ];
}
