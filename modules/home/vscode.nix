{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = (with pkgs.vscode-extensions; [
        llvm-vs-code-extensions.vscode-clangd
        editorconfig.editorconfig
        usernamehw.errorlens
        dbaeumer.vscode-eslint
        tamasfe.even-better-toml
        eamodio.gitlens
        jdinhlife.gruvbox
        james-yu.latex-workshop
        bierner.markdown-mermaid
        pkief.material-icon-theme
        pkief.material-product-icons
        jnoortheen.nix-ide
        christian-kohler.path-intellisense
        esbenp.prettier-vscode
        rust-lang.rust-analyzer
        timonwong.shellcheck
        vscodevim.vim
        wakatime.vscode-wakatime
      ]);
    };
  };
}