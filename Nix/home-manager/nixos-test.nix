{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ./common.nix ];

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    riot-web
    signal-desktop
    vscode
    yubioath-desktop
  ];

  home.file = {
    # Make OCaml plugin inactive.
    ".zsh/ocaml.zsh".target = ".zsh/ocaml.zsh__";
  };

  # Specific Git configuration
  programs.git = {
    signing.signByDefault = mkForce false;
    extraConfig.credential.helper = "store";
  };

  programs.zsh = {
    # Add nix because auto-completion does not work out of the box on non NixOS
    # or nix-darwin platform for now.
    oh-my-zsh.plugins = [ "nix" ];

    shellAliases = {
      # Commandes fréquentes.
      op = "xdg-open";
    };
  };
}
