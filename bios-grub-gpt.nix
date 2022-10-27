{ pkgs, self, ... }: {
  proxmox = {
    qemuConf = { bios = "seabios"; };
    partitionTableType = "legacy+gpt";
  };
  system.nixos.tags = [ "bios-grub-gpt" ];
}
