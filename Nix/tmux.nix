{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs) stdenv;
  tmuxConfig = builtins.readFile ../tmux-2.4.conf;
in

{
  programs.tmux = if stdenv.isDarwin then {
    enable = true;
    tmuxConfig = tmuxConfig + ''
        bind-key -T copy-mode Enter send-keys -X copy-pipe-and-cancel "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace pbcopy"
      '';
  } else {
    enable = true;
    extraTmuxConf = tmuxConfig + ''
        bind-key -T copy-mode Enter send-keys -X copy-selection-and-cancel
      '';
  };
}
