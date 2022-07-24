{ pkgs, self, ... }: {
  proxmox = {
    qemuConf = { bios = "seabios"; };
    diskPartitioning = "hybrid";
  };
  system.nixos.tags = [ "bios-hybrid-grub" ];
}
