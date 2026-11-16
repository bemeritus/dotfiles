{
  description = "flakes for m[A]chines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

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
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    homeModules.git = ./modules/home/git.nix;
    homeModules.starship = ./modules/home/starship.nix;

    devShells.${system}.default = import ./shell.nix {inherit pkgs inputs;};

    systems.modules.nixos = with inputs; [];

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

              extraSpecialArgs = {inherit inputs;};
              users.bemeritus = ./machines/home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
  };
}
