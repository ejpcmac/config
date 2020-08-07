################################################################################
##                                                                            ##
##                  User declaration for jpc on workstations                  ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  users.users.jpc = {
    extraGroups = [
      "cdrom"
      "dialout"
      "networkmanager"
      "plugdev"
      "video"
      "wireshark"
    ];
  };
}
