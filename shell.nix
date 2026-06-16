{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "nix";

  nativeBuildInputs = with pkgs; [
    nixd
    statix
    deadnix
    alejandra
  ];

  # Nix related configurations
  NIX_CONFIG = "extra-experimental-features = nix-command flakes pipe-operators";
}
