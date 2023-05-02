################################################################################
##                                                                            ##
##              Configuration for containers deployed on neptune              ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

{
  config = lib.mkIf (config.confkit.info.location == "neptune") {

    ########################################################################
    ##                        Location & Time Zone                        ##
    ########################################################################

    location = {
      latitude = 50.69;
      longitude = 3.18;
    };

    time.timeZone = "Europe/Paris";

    ########################################################################
    ##                       General configuration                        ##
    ########################################################################

    users.groups = {
      tls.gid = 993;
    };

    ########################################################################
    ##                   Network-specific configuration                   ##
    ########################################################################

    networking.hosts = {
      # Local containers
      # ***[ REDACTED ]***
    };
  };
}
