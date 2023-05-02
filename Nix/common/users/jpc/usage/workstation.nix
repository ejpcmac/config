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
      "networkmanager"
      "plugdev"
      "video"
      "wireshark"
    ];
  };
}
