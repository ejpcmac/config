################################################################################
##                                                                            ##
##                            Nomade configuration                            ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

{
  config = lib.mkIf (config.confkit.info.location == "nomade") {

    ########################################################################
    ##                        Location & Time Zone                        ##
    ########################################################################

    location = {
      latitude = 52.37;
      longitude = 4.89;
    };

    time.timeZone = "Europe/Amsterdam";
  };
}
