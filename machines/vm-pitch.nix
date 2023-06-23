{ config, pkgs, ... }:

{
  imports = [
    ../modules/vmware-guest.nix
    ./vm-shared.nix
    ../hardware/vm-aarch64-fusion.nix
  ];

  # Disable the original vmware module and use mitchellh's override
  disabledModules = [ "virtualisation/vmware-guest.nix" ];

  # Enable vmware guest support
  virtualisation.vmware.guest = {
    enable = true;
    # TODO: For some reason, installation fails with headless = true. Need to figure out why
    # headless = true;
  };

  # Networking setup
  networking.hostName = "pitch";

  # Package installation
  environment.systemPackages = with pkgs; [
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
    initialScript = pkgs.writeText "postgresql initscript" ''
      CREATE ROLE pitch WITH LOGIN PASSWORD 'pitch' CREATEDB;
      CREATE DATABASE pitch-development;
    '';
    ensureUsers = [{
      name = "fred";
      ensureClauses.superuser = true;
      ensureClauses.login = true;
    }];
  };

  services.redis.servers = {
    pitch = {
      enable = true;
      port = 6379;
    };
  };

  # Share our host filesystem
  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/";
    options = [
      "umask=22"
      "uid=1000"
      "gid=1000"
      "allow_other"
      "auto_unmount"
      "defaults"
    ];
  };
}
