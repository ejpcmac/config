################################################################################
##                                                                            ##
##                           Configuration for OVH                            ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

{
  config = lib.mkIf (config.confkit.info.location == "ovh") {

    ########################################################################
    ##                        Location & Time Zone                        ##
    ########################################################################

    location = {
      latitude = 50.69;
      longitude = 3.18;
    };

    time.timeZone = "Europe/Paris";
  };
}
