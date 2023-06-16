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
    gcc
    gnumake
    git
    vim

    bundix
    ruby
    nodejs_18
    postgresql
    yarn
    mupdf
    vips
    redis
  ];

  services.postgresql = {
    enable = true;
    enableTCPIP = true;
  };

  services.redis.servers = {
    pitch = {
      enable = true;
      port = 6379;
    };
  };
}
