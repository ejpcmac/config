##
## nixos-test users
##

{ config, pkgs, ... }:

{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;

    users.root = {
      hashedPassword = "***";
    };

    users.jpc = {
      isNormalUser = true;
      uid = 1000;
      description = "Jean-Philippe Cugnet";
      extraGroups = [ "wheel" "dialout" "wireshark" ];
      hashedPassword = "***";
    };
  };
}
