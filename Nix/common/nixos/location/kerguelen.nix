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
    timeServers = [ "0.ntp.kerguelen.ipev.fr" "1.ntp.kerguelen.ipev.fr" ];

    proxy = {
      default = "***[ REDACTED ]***";
    };
  };

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
