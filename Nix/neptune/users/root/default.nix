################################################################################
##                                                                            ##
##                     User declaration for root@neptune                      ##
##                                                                            ##
################################################################################

let
  inherit (builtins) readFile;
in

{
  users.users.root = {
    # Use `mkpasswd -m SHA-512` to generate a new password hash.
    hashedPassword = "***[ REDACTED ]***";
    openssh.authorizedKeys.keys = [
      (readFile "***[ REDACTED ]***")
    ];
  };

  home-manager.users.root = import ./home.nix;
}
