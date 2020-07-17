################################################################################
##                                                                            ##
##                    Configuration for the Samba feature                     ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

{
  ############################################################################
  ##                                Firewall                                ##
  ############################################################################

  networking.firewall = {
    allowedTCPPorts = [ 139 445 ];
    allowedUDPPorts = [ 137 138 ];
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    samba
  ];

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    # Enable avahi for auto-discovering Samba shares.
    avahi = {
      enable = true;
      nssmdns = true;
      publish = { enable = true; userServices = true; };
    };

    samba = {
      enable = true;
      extraConfig = ''
        guest account = nobody
        map to guest = bad user
      '';

      shares = {
        Musique = {
          path = "/data/Musique";
          public = "yes";
          browsable = "yes";
          writeable = "yes";
          "guest ok" = "yes";
        };

        "Vidéos" = {
          path = "/data/Vidéos";
          public = "yes";
          browsable = "yes";
          writeable = "yes";
          "guest ok" = "yes";
        };

        Logiciels = {
          path = "/data/Logiciels";
          public = "yes";
          browsable = "yes";
          writeable = "yes";
          "guest ok" = "yes";
        };

        "Time Machine" = {
          path = "/data/Backup/MacBook-JP";
          public = "no";
          writeable = "yes";
          "valid users" = "jpc";
          "fruit:aapl" = "yes";
          "fruit:time machine" = "yes";
          "vfs objects" = "catia fruit streams_xattr";
        };
      };
    };
  };
}
