################################################################################
##                                                                            ##
##                     Configuration for the ZFS feature                      ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

{
  config = lib.mkIf config.confkit.features.zfs.enable {

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      zfs = {
        autoScrub.interval = "Sun, 20:00";
      };
    };
  };
}
