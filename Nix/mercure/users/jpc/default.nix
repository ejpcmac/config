################################################################################
##                                                                            ##
##                      User declaration for jpc@mercure                      ##
##                                                                            ##
################################################################################

{
  imports = [
    # Configuration shared between hosts.
    ../../../common/users/jpc/general.nix
    ../../../common/users/jpc/usage/workstation.nix
  ];

  users.users.jpc = {
    # Use `mkpasswd -m SHA-512` to generate a new password hash.
    hashedPassword = "***[ REDACTED ]***";
    extraGroups = [ "docker" ];
  };

  home-manager.users.jpc = import ./home.nix;
}
