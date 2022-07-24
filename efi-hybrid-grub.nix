{ pkgs, self, ... }: {
  proxmox = {
    qemuConf = { bios = "ovmf"; };
    diskPartitioning = "hybrid";
  };
  system.nixos.tags = [ "efi-hybrid-grub" ];
}
