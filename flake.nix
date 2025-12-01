{
  description = "flakes for m[A]chines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # xinux-plymouth-theme = {
    #   url = "github:bemeritus/xinux-plymouth-theme";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    mac-style-plymouth = {
      url = "github:bemeritus/bemeritus-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # framework-plymouth.url = "github:Costeer/framework-mocha-plymouth-theme";
  };

  outputs = inputs @ {
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

    devShells.${system}.default = pkgs.mkShell {
      name = "nix-dev-shell";
      buildInputs = [pkgs.alejandra];
      shellHook = ''
        echo "Welcome to the Nix dev shell with Alejandra formatter!"
      '';
    };

    nixosConfigurations = {
      bemeritus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./machines/configuration.nix

          # framework-plymouth.nixosModules.default
          # mac-style-plymouth.overlays.default

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
