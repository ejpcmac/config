{ config, pkgs, ... }:

let
  inherit (pkgs) stdenv;
in

{
  environment.shells = [ pkgs.zsh ];

  programs.zsh = let zsh-common = {
    enable = true;
    enableCompletion = true;

    interactiveShellInit = builtins.readFile ./zsh/config.zsh;
    promptInit = builtins.readFile ./zsh/prompt.zsh;
  }; in
  if stdenv.isDarwin then zsh-common // {
    enableBashCompletion = true;

    variables = {
      HISTORY = "10000";
      SAVEHIST = "10000";
      HISTFILE = "$HOME/.zsh_history";
    };
  }
  else zsh-common;
}
