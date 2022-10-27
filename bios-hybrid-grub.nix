{ pkgs, self, ... }: {
  proxmox = {
    qemuConf = { bios = "seabios"; };
    partitionTableType = "hybrid";
  };
  system.nixos.tags = [ "bios-hybrid-grub" ];
}
