{ pkgs, self, config, ... }: {
  proxmox = {
    qemuConf = {
      agent = true;
      memory = 2048;
      net0 = "virtio=00:00:00:00:00:00,bridge=vmbr0,firewall=1";
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

  services.cloud-init = {
    enable = true;
    # must be same value as 'networking.useNetworkd'
    network.enable = config.networking.useNetworkd;
  };

  services.openssh = {
    enable = true;
    settings = { PasswordAuthentication = false; };
  };

  # avoid long build time
  documentation.enable = false;

}
