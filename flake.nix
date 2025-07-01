{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = input@{ self, nixpkgs, home-manager, ... }: 
  {
    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    nixosConfigurations = {
      bemeritus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.bemeritus = ./home.nix;
                backupFileExtension = "backup";
              };

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
          }
        ];
      };
    };
    

  };
}
