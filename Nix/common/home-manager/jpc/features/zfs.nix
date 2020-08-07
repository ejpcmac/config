################################################################################
##                                                                            ##
##              Home configuration for jpc with the ZFS feature               ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

{
  ############################################################################
  ##                                Aliases                                 ##
  ############################################################################

  confkit.zsh.plugins = [ "zfs" ];

  programs.zsh.shellAliases = {
    zly = "zfs list -o name,jpc:manager,readonly,compression,compressratio,used,usedbysnapshots,com.sun:auto-snapshot";
    wzly = "watch -n 1 zfs list -o name,jpc:manager,readonly,compression,compressratio,used,usedbysnapshots,com.sun:auto-snapshot";
  };
}
