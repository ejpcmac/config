################################################################################
##                                                                            ##
##                  User declaration for jpc on workstations                  ##
##                                                                            ##
################################################################################

{
  users.users.jpc = {
    extraGroups = [
      "cdrom"
      "dialout"
      "lp"
      "networkmanager"
      "plugdev"
      "scanner"
      "video"
      "wireshark"
    ];
  };
}
