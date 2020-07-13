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
      hashedPassword = "***[ REDACTED ]***";
    };

    users.jpc = {
      isNormalUser = true;
      createHome = false;
      uid = 1000;
      description = "Jean-Philippe Cugnet";
      hashedPassword = "***[ REDACTED ]***";
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

  # Import the home-manager NixOS module.
  imports = [ ../../../home-manager/nixos ];

  # Configure home-manager for each user.
  home-manager.users = {
    root = import ../../../confkit/Nix/user/root.nix;
    jpc = import ./jpc;
  };
}
