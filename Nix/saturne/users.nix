################################################################################
##                                                                            ##
##                               Saturne users                                ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;

    users.root = {
      # Use `mkpasswd -m SHA-512` to generate a new password hash.
      hashedPassword = "***";
    };

    users.jpc = {
      isNormalUser = true;
      createHome = false;
      uid = 1000;
      description = "Jean-Philippe Cugnet";
      hashedPassword = "***";
      extraGroups = [
        "wheel"
        "cdrom"
        "dialout"
        "docker"
        "networkmanager"
        "plugdev"
        "vboxusers"
        "video"
        "wireshark"
      ];
    };

    groups.plugdev = {};
  };
}
