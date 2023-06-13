{
  description = "NixOS-based systems declarations by fredoliveira";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      replica = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./machines/vm-replica.nix
        ];
      };

      pitch = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./machines/vm-pitch.nix
        ];
      };
    };
  };
}
