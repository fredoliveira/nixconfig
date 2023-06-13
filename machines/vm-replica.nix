{ config, pkgs, ... }:

{
  imports = [
    ./vm-shared
    ../hardware/vm-aarch64-fusion.nix
  ];

  # Networking setup
  networking.hostName = "replica";

  # Package installation
  environment.systemPackages = with pkgs; [
    wget
  ];
}
