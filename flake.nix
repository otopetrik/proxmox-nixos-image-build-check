{
  inputs = {
    nixpkgs = {
      #type = "git";
      #url = "file:///home/....../nixpkgs?ref=proxmox-image-uefi";
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # to build one:
  #   nix build .#efi-systemd-boot
  #
  # to build all:
  #   nix build .#
  #
  # to import single vm (as VMID 900):
  #
  #   ssh root@proxmox.example.com "unzstd | qmrestore - 900 --storage local-zfs" < result/vzdump-qemu-nixos-efi-systemd-boot-*.vma.zst
  #
  # to import all (starting with VMID 950):
  #   result/upload.sh proxmox.example.com 950 local-zfs
  #
  # or import with replacing exisiting VMs/templates (DANGEROUS !)
  #   result/upload.sh proxmox.example.com 950 local-zfs --force
  #
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-generators,
    }@inputs:
    {

      packages.x86_64-linux =
        let
          saveRev = (
            { pkgs, ... }:
            {
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            }
          );
          bios-grub = nixos-generators.nixosGenerate {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            format = "proxmox";
            modules = [
              ./common.nix
              ./bios-grub.nix
              saveRev
            ];
            specialArgs = {
              inherit inputs;
            };
          };
          bios-grub-gpt = nixos-generators.nixosGenerate {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            format = "proxmox";
            modules = [
              ./common.nix
              ./bios-grub-gpt.nix
              saveRev
            ];
            specialArgs = {
              inherit inputs;
            };
          };
          bios-hybrid-grub = nixos-generators.nixosGenerate {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            format = "proxmox";
            modules = [
              ./common.nix
              ./bios-hybrid-grub.nix
              saveRev
            ];
            specialArgs = {
              inherit inputs;
            };
          };
          efi-grub = nixos-generators.nixosGenerate {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            format = "proxmox";
            modules = [
              ./common.nix
              ./efi-grub.nix
              saveRev
            ];
            specialArgs = {
              inherit inputs;
            };
          };
          efi-hybrid-grub = nixos-generators.nixosGenerate {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            format = "proxmox";
            modules = [
              ./common.nix
              ./efi-hybrid-grub.nix
              saveRev
            ];
            specialArgs = {
              inherit inputs;
            };
          };
          efi-systemd-boot = nixos-generators.nixosGenerate {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            format = "proxmox";
            modules = [
              ./common.nix
              ./efi-systemd-boot.nix
              saveRev
            ];
            specialArgs = {
              inherit inputs;
            };
          };
          proxmox-images =
            with import nixpkgs { system = "x86_64-linux"; };
            stdenv.mkDerivation {
              name = "proxmox-images";
              src = self;
              buildInputs = [
                bios-grub
                bios-grub-gpt
                bios-hybrid-grub
                efi-grub
                efi-hybrid-grub
                efi-systemd-boot
              ];
              buildPhase = "";
              installPhase = ''
                mkdir $out
                cp ${bios-grub}/*.vma.zst $out/
                cp ${bios-grub-gpt}/*.vma.zst $out/
                cp ${bios-hybrid-grub}/*.vma.zst $out/
                cp ${efi-grub}/*.vma.zst $out/
                cp ${efi-hybrid-grub}/*.vma.zst $out/
                cp ${efi-systemd-boot}/*.vma.zst $out/
                cat << 'EOF' > $out/upload.sh
                #!/bin/bash
                set -euo pipefail

                # Use 'result/upload.sh proxmox.example.com 950 local-zfs --force'
                # to overwrite existing VMs. Does NOT ask for confirmation !
                HOST="''${1:-proxmox.example.com}"
                VMID="''${2:-950}"
                STORAGE="''${3:-local-zfs}"
                FORCE="''${4:-}"

                ls $(dirname "$0")/*.vma.zst | sort | while read IMG ; do
                echo "Uploading $IMG as $VMID"
                ssh root@$HOST "unzstd | qmrestore - $VMID $FORCE --storage $STORAGE" < $IMG
                ssh root@$HOST "qm template $VMID" < /dev/null
                ((VMID++))
                done
                EOF
                chmod +x $out/upload.sh
              '';
            };
        in
        {
          inherit bios-grub bios-grub-gpt bios-hybrid-grub;
          inherit efi-grub efi-hybrid-grub efi-systemd-boot;
          inherit proxmox-images;
          default = proxmox-images;
        };
    };
}
