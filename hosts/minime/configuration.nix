# hosts/minime/configuration.nix
{ config, inputs, outputs, pkgs, ... }:

{
  # Import the home-manager module for NixOS
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;

  # Networking
  networking.hostName = "minime";
  networking.networkmanager.enable = true;

  # --- CRITICAL: MMC Write-Reduction Settings ---
  swapDevices = [ ];
  fileSystems."/" = { options = [ "noatime" ]; };
  fileSystems."/var/log" = { fsType = "tmpfs"; options = [ "defaults" "size=256m" ]; };
  fileSystems."/tmp" = { fsType = "tmpfs"; options = [ "defaults" "size=1g" ]; };

  # --- ZFS and Flakes ---
  # This is the option that was causing the error. It's now correctly placed.
  boot.zfs.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # --- System Packages ---
  environment.systemPackages = with pkgs; [ vim git ];

  # --- User and SSH ---
  users.users.joe = {
    isNormalUser = true;
    description = "Joe";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDdlc/TJrgReahwu3fzLdZ63d7ncp6tUa+pODwGD/Jjw home"
    ];
  };

  # --- Home Manager Integration ---
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
    users.joe = import ../../home/joe/${config.networking.hostName}.nix;
  };

  services.openssh.enable = true;
  system.stateVersion = "23.11";
}