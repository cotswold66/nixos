{
  description = "NixOS and Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, home-manager, nixpkgs,  ... }: {
    nixosConfigurations = {
      pluto = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # specialArgs = { inherit inputs; };
        modules = [
          ./hosts/pluto
          # ./syncthing.nix
          # ./sway.nix
          # ./email.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = inputs;
              users.john = import ./johnlord.nix;
            };
          }
        ];
      };
    };
  };
}
