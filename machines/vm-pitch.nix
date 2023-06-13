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

    ruby
    nodejs_18
    postgresql.lib
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
