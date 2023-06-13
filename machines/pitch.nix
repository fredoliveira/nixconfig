{ config, pkgs, ... }:

{
  imports =
    [
      ../hardware/vm-aarch64.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking setup
  networking.hostName = "pitch";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # User configuration
  users.users.root = {
    initialPassword = "root";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGHOncfJWwsXugVSekXQTWouJ8kGkPmfsO92KE2UbGTF"
    ];
  };

  users.users.fred = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGHOncfJWwsXugVSekXQTWouJ8kGkPmfsO92KE2UbGTF"
    ];
  };

  # Users in the wheel group don't need a password to sudo
  security.sudo.wheelNeedsPassword = false;

  # OpenSSH configuration
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";

  nix.package = pkgs.nixUnstable;
 	nix.extraOptions = "experimental-features = nix-command flakes";

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
