################################################################################
##                                                                            ##
##                                Helios users                                ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;

    users = {
      root = {
        # Use `mkpasswd -m SHA-512` to generate a new password hash.
        hashedPassword = "***[ REDACTED ]***";
      };

      jpc = {
        isNormalUser = true;
        createHome = false;
        uid = 1000;
        description = "Jean-Philippe Cugnet";
        extraGroups = [ "wheel" "data" "musique" "videos" "docs" "transmission" ];
        hashedPassword = "***[ REDACTED ]***";
      };

      # Other users…
    };

    groups = {
      data.gid = 2000;
      musique.gid = 2001;
      videos.gid = 2002;
      docs.gid = 2003;
    };
  };

  # Import the home-manager NixOS module.
  imports = [ ../../../home-manager/nixos ];

  # Configure home-manager for each user.
  home-manager.users = {
    root = import ./root;
    jpc = import ./jpc;
  };
}
