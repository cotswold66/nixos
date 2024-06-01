{
  description = "NixOS and Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    base16-shell = {
      url = "github:cotswold66/base16-shell";
      flake = false;
    };
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs @ { self, home-manager, nixpkgs, base16-shell, sops-nix, ... }: {
    nixosConfigurations = {
      "pluto" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/pluto/configuration.nix
          sops-nix.nixosModules.sops
        ];
      };
      "saturn" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/saturn/configuration.nix
          sops-nix.nixosModules.sops
        ];
      };
    };
    homeConfigurations = {
      "john@pluto" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/pluto/home.nix
        ];
      };
      "john@saturn" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/saturn/home.nix
        ];
      };
    };
  };
}
