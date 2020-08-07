################################################################################
##                                                                            ##
##                     User declaration for root@saturne                      ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  users.users.root = {
    # Use `mkpasswd -m SHA-512` to generate a new password hash.
    hashedPassword = "***[ REDACTED ]***";
  };

  home-manager.users.root = import ../../../../confkit/home-manager/configs/root.nix;
}
