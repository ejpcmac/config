{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ./common.nix ];

  # This is a single-user installation, so there is no system environment. Thus
  # I install here a little bit more than just user packages.
  home.packages = with pkgs; [
    docker
    docker_compose
    emv
    git-lfs
    gnupg
    htop
    nix-prefetch-github
    nox
    openssh
    rsync
    wget
    xz
  ];

  home.file = {
    # eft-jpc-specific config
    ".zsh/fedora.zsh".source = ../../zsh/fedora.zsh;
    ".zsh/gpg-agent.zsh".source = ../../zsh/gpg-agent.zsh;
  };

  # Specific Git configuration
  programs.git = {
    userEmail = mkForce "***";
    extraConfig.credential.helper = "store";
  };

  # Enable Vim here since the system configuration is not handled.
  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ../../vimrc
      + builtins.readFile ../../vim/colors/wellsokai.vim;
  };

  programs.zsh = {
    initExtra = mkForce (''
      if [ -z "$IN_NIX_SHELL" ]; then
          source $HOME/.nix-profile/etc/profile.d/nix.sh
      fi
    '' + builtins.readFile ./zsh/init.zsh);

    # Add nix because auto-completion does not work out of the box on non NixOS
    # or nix-darwin platform for now.
    oh-my-zsh.plugins = [ "dnf" "nix" ];

    shellAliases = {
      # Commandes fréquentes.
      op = "xdg-open";
    };
  };
}
