{
  description = "NixOS and Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    base16-shell = {
      url = "github:cotswold66/base16-shell";
      flake = false;
    };
  };

  outputs = inputs @ { self, home-manager, nixpkgs, base16-shell, ... }: {
    nixosConfigurations = {
      "pluto" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/pluto
        ];
      };
      "saturn" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/saturn
        ];
      };
    };
    homeConfigurations = {
      "john@pluto" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home/john/pluto.nix ];
      };
      "john@saturn" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home/john/saturn.nix ];
      };
    };
  };
}
