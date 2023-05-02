################################################################################
##                                                                            ##
##                      User declaration for root@pluton                      ##
##                                                                            ##
################################################################################

{ inputs, ... }:

{
  users.users.root = {
    # Use `mkpasswd -m SHA-512` to generate a new password hash.
    hashedPassword = "***[ REDACTED ]***";
  };

  home-manager.users.root = inputs.confkit.nixosModules.home-config-root;
}
