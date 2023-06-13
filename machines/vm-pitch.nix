{ config, pkgs, ... }:

{
  imports = [
    ./vm-shared.nix
    ../hardware/vm-aarch64-fusion.nix
  ];

  # Networking setup
  networking.hostName = "pitch";

  # Package installation
  environment.systemPackages = with pkgs; [
    git
    ruby_3_2
    nodejs_18
    postgresql
    yarn
    mupdf
    vips
  ];
}
