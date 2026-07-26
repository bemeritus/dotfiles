{
  description = "flakes for m[A]chines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-style-plymouth = {
      url = "github:bemeritus/bemeritus-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-data = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/nix-data?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xinux-settings = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/settings?ref=app-sandbox&shallow=1";
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
    xinux-settings,
    nixpak,
    mac-style-plymouth,
    nix-data,
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
