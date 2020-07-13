################################################################################
##                                                                            ##
##                        Configuration for Kerguelen                         ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

{
  ############################################################################
  ##                          Location & Time Zone                          ##
  ############################################################################

  location = {
    latitude = -49.35;
    longitude = 70.22;
  };

  time.timeZone = "Indian/Kerguelen";

  ############################################################################
  ##                     Network-specific configuration                     ##
  ############################################################################

  networking = {
    search = [ "kerguelen.ipev.fr" ];

    proxy = {
      default = "***[ REDACTED ]***";
    };
  };

  services.ntp.servers = [ "time2.kerguelen.ipev.fr" "time.kerguene.ipev.fr" ];

  # Local network drives.
  fileSystems = {
    # Mount network drives (REDACTED).
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    cifs-utils
  ];
}
