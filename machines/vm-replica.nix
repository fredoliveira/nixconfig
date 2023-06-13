{ config, pkgs, ... }:

{
  imports = [
    ./vm-shared.nix
    ../hardware/vm-aarch64-fusion.nix
  ];

  # Networking setup
  networking.hostName = "replica";

  # Package installation
  environment.systemPackages = with pkgs; [
    wget
  ];
}
