{ config, pkgs, ... }:

let
  environment = (import ../environment.nix { inherit config pkgs; }).environment;
in

{
  home.file = {
    # Zsh aliases and environments
    ".zsh/aliases.zsh".source = ../../zsh/aliases.zsh;
    ".zsh/nix.zsh".source = ../../zsh/nix.zsh;

    # Zsh themes
    ".zsh-custom/themes/bazik.zsh-theme".source = ../../zsh/themes/bazik.zsh-theme;
  };

  programs.home-manager = {
    enable = true;
    path = https://github.com/rycee/home-manager/archive/master.tar.gz;
  };

  programs.zsh = {
    enable = true;

    initExtra = ''
      for script ($HOME/.zsh/*.zsh); do
        source $script
      done
      unset script
    '';

    oh-my-zsh = {
      enable = true;

      custom = "$HOME/.zsh-custom";
      theme = "bazik";
      plugins = [ "git" "zsh-syntax-highlighting" ];
    };

    inherit (environment) shellAliases;
  };
}
