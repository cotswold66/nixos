{
  description = "NixOS and Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, home-manager, nixpkgs, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
      { 
        nixosModules = import ./modules { lib = nixpkgs.lib; }; 
        nixosConfigurations = {
          pluto = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs; };
            modules = [
              ./pluto.nix
              ./johnlord.nix
              # ./profiles/sway.nix
              # ./profiles/email.nix
              nixos-hardware.nixosModules.dell-xps-13-9300
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs; };
                };
              }
            ];
          };
        };
      };
}
