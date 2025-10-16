# hosts/minime/default.nix
{ inputs, outputs, ... }:

{
  imports = [
    # Import settings shared across all your hosts
    ../common

    # Import the hardware-specific configuration
    ./hardware-configuration.nix

    # Import the main configuration for this specific host
    ./configuration.nix
  ];
}