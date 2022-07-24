{ pkgs, self, ... }: {
  proxmox = {
    qemuConf = {
      agent = true;
      memory = 2048;
      net0 = "virtio=00:00:00:00:00:00,bridge=vmbr0,firewall=1";
      #net0 = "virtio=00:00:00:00:00:00,bridge=vmbr1,firewall=1";
    };
    qemuExtraConf = { machine = "q35"; };
  };
  services.qemuGuest.enable = true;

  system.stateVersion = "22.05";

  # we want 'eth0', not 'enp6' or 'enp6s18'
  boot.kernelParams = [ "net.ifnames=0" ];

  # Network configuration.
  networking.useNetworkd = true;
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # avoid long build time
  documentation.enable = false;

  # WARNING: do not use following line for real images
  users.users.root.initialPassword = "";
}
