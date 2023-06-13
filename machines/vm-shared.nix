# Configuration options shared by all VMs
{ config, pkgs, ...}:

{
  nix.package = pkgs.nixUnstable;
 	nix.extraOptions = "experimental-features = nix-command flakes";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Console mode setup
  boot.loader.systemd-boot.consoleMode = "0";

  # Networking
  networking.networkmanager.enable = true;

  # Timezone setup
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Add tailscale to every VM
  # TODO: Still need to authenticate manually, at least for now
  services.tailscale.enable = true;

  # Add docker support inside the VMs
  virtualisation.docker.enable = true;

  # User configuration
  users.mutableUsers = false;

  users.users.root = {
    initialPassword = "root";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGHOncfJWwsXugVSekXQTWouJ8kGkPmfsO92KE2UbGTF"
    ];
  };

  users.users.fred = {
    isNormalUser = true;
    extraGroups = [ "wheel", "docker" ];
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

  # No need for a firewall in our VMs
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # Setup auto upgrades
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";
}
