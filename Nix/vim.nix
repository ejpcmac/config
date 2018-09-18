{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs) stdenv;

  vimConfig = builtins.readFile ../vimrc
    + builtins.readFile ../vim/colors/wellsokai.vim;
in

{
  environment.systemPackages = if stdenv.isLinux then [
    (pkgs.vim_configurable.customize {
      name = "vim";
      vimrcConfig.customRC = vimConfig;
    })
  ] else [];

  programs.vim = if stdenv.isDarwin then {
    enable = true;
    vimConfig = vimConfig + "set clipboard=unnamed";
  } else {
    defaultEditor = true;
  };
}
