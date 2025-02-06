{
  config,
  lib,
  inputs,
  ...
}:
let
  channelBase = "/etc/nixpkgs/channels";
  nixpkgsStablePath = "${channelBase}/nixpkgs-stable";
  nixpkgsUnstablePath = "${channelBase}/nixpkgs-unstable";

in
{
  systemd.tmpfiles.rules = [
    "L+ ${nixpkgsStablePath} - - - - ${inputs.nixpkgs}"
    "L+ ${nixpkgsUnstablePath} - - - - ${inputs.nixpkgs-unstable}"
  ];

  nix = {
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
    };
    # NOTE: 'nixpkgs' is required for 'nix-shell -p whatever' to actually work
    # (it does not work if it is set to 'nixos' or something else...)
    nixPath = [
      "nixpkgs=${nixpkgsStablePath}"
      "nixpkgs-unstable=${nixpkgsUnstablePath}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
