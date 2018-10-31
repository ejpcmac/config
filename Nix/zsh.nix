{ config, pkgs, ... }:

let
  inherit (pkgs) stdenv;
  shellInit = builtins.readFile ./zsh/config.zsh;
in

{
  environment.shells = [ pkgs.zsh ];

  programs.zsh = let zsh-common = {
    enable = true;
    enableCompletion = true;

    interactiveShellInit = shellInit;
    promptInit = builtins.readFile ./zsh/prompt.zsh;
  }; in
  if stdenv.isDarwin then zsh-common // {
    interactiveShellInit = shellInit + builtins.readFile ./zsh/macos.zsh;
    enableBashCompletion = true;

    variables = {
      HISTORY = "10000";
      SAVEHIST = "10000";
      HISTFILE = "$HOME/.zsh_history";
    };
  }
  else zsh-common;
}
