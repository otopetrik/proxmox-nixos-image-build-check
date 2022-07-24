{ pkgs, self, ... }: {
  proxmox = {
    qemuConf = { bios = "seabios"; };
    diskPartitioning = "legacy+gpt";
  };
  system.nixos.tags = [ "bios-grub-gpt" ];
}
