################################################################################
##                                                                            ##
##              Home configuration for jpc with the ZFS feature               ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  confkit = import ../../../../../confkit;
in

{
  ############################################################################
  ##                                Aliases                                 ##
  ############################################################################

  home.file.".zsh/zfs.zsh".source = confkit.file "zsh/zfs.zsh";

  programs.zsh.shellAliases = {
    zly = "zfs list -o name,jpc:manager,readonly,compression,compressratio,used,usedbysnapshots,com.sun:auto-snapshot";
    wzly = "watch -n 1 zfs list -o name,jpc:manager,readonly,compression,compressratio,used,usedbysnapshots,com.sun:auto-snapshot";
  };
}
