{
  description = "NixOS and Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, home-manager, nixpkgs, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
      { 
        nixosConfigurations = {
          pluto = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = inputs;
            modules = [
              ./hosts/pluto/configuration.nix
              nixos-hardware.nixosModules.dell-xps-13-9300
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.john = import ./home/john/pluto.nix;
                  extraSpecialArgs = inputs;
                };
              }
            ];
          };
        };
        
        # homeConfigurations = {
        #   "john@pluto" = home-manager.lib.homeManagerConfiguration {
        #     inherit pkgs;
        #     extraSpecialArgs = inputs;
        #     modules = [ ./home/john/pluto.nix ];
        #   };
        # };
      };
}
