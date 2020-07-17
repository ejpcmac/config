################################################################################
##                                                                            ##
##             Configuration for hosts booting with systemd-boot              ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

{
  ############################################################################
  ##                          Boot & File systems                           ##
  ############################################################################

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    timeout = 1;
  };
}
