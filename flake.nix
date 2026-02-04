{
  description = "flakes for m[A]chines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-style-plymouth = {
      url = "github:bemeritus/bemeritus-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    mac-style-plymouth,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    homeModules.git = ./modules/home/git.nix;
    homeModules.starship = ./modules/home/starship.nix;

    devShells.${system}.default = import ./shell.nix {inherit pkgs inputs;};

    nixosConfigurations = {
      bemeritus = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./machines/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.bemeritus = ./machines/home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
  };
}
