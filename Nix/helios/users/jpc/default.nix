################################################################################
##                                                                            ##
##                      User declaration for jpc@helios                       ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  imports = [
    # Configuration shared between hosts.
    ../../../common/users/jpc/general.nix
  ];

  users.users.jpc = {
    # Use `mkpasswd -m SHA-512` to generate a new password hash.
    hashedPassword = "***[ REDACTED ]***";
    extraGroups = [ "data" "musique" "videos" "docs" "transmission" ];
  };

  home-manager.users.jpc = import ./home.nix;
}
