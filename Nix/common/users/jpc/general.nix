################################################################################
##                                                                            ##
##                      General user declaration for jpc                      ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  users.users.jpc = {
    isNormalUser = true;
    createHome = false;
    uid = 1000;
    description = "Jean-Philippe Cugnet";
    extraGroups = [ "wheel" "chrony" ];
  };
}
