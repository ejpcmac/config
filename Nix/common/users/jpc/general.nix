################################################################################
##                                                                            ##
##                      General user declaration for jpc                      ##
##                                                                            ##
################################################################################

{
  users.users.jpc = {
    isNormalUser = true;
    uid = 1000;
    description = "Jean-Philippe Cugnet";
    extraGroups = [ "wheel" "chrony" ];
    openssh.authorizedKeys.keyFiles = [ "***[ REDACTED ]***" ];
  };
}
