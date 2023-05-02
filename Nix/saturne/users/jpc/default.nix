################################################################################
##                                                                            ##
##                      User declaration for jpc@saturne                      ##
##                                                                            ##
################################################################################

{
  imports = [
    # Configuration shared between hosts.
    ../../../common/users/jpc/general.nix
    ../../../common/users/jpc/usage/workstation.nix
  ];

  users.users.jpc = {
    createHome = false;
    # Use `mkpasswd -m SHA-512` to generate a new password hash.
    hashedPassword = "***[ REDACTED ]***";
    extraGroups = [ "docker" "vboxusers" ];
  };

  home-manager.users.jpc = import ./home.nix;
}
