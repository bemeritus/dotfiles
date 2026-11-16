{
  description = "flakes for m[A]chines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my-nautilus = {
      url = "github:yannmasoch/nautilus-my-computer?dir=packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    home-manager,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      flake = {
        homeModules.git = ./modules/home/git.nix;
        homeModules.starship = ./modules/home/starship.nix;

        nixosConfigurations.bemeritus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs;};
          modules = [
            ./machines/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                extraSpecialArgs = {inherit inputs;};
                users.bemeritus = ./machines/home.nix;
                backupFileExtension = "backup";
              };
            }
          ];
        };
      };

      perSystem = {pkgs, ...}: {
        devShells.default = import ./shell.nix {inherit pkgs inputs;};
      };
    };
}
