################################################################################
##                                                                            ##
##                     Home configuration for root@helios                     ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

let
  inherit (builtins) readFile;
in

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  home.stateVersion = "19.09";  # Did you read the comment?

  # Base on the root home configuration from confkit.
  imports = [ ../../../../confkit/home-manager/configs/root.nix ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    identity = {
      name = "Helios";
      email = "root@helios";
    };

    git.enable = true;
    zsh.plugins = [ "git" "zfs" ];
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs.git = {
    extraConfig.credential.helper = "store";
  };
}
