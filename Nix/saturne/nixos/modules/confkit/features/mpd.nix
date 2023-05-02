################################################################################
##                                                                            ##
##                     Configuration for the MPD feature                      ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.confkit.features.custom.saturne.mpd;
  mkFs = pkgs.lib.confkit.mkFs config;
in

{
  options.confkit.features.custom.saturne.mpd = {
    enable = mkEnableOption "the MPD feature";
  };

  config = mkIf cfg.enable {

    ########################################################################
    ##                            File systems                            ##
    ########################################################################

    fileSystems = {
      "/persist/mpd" = mkFs { volumePath = "/system/data/mpd"; };
    };

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      mpd = {
        enable = true;
        musicDirectory = "/data/Musique";
        dataDir = "/persist/mpd";
        extraConfig = builtins.readFile ../../../../res/mpd.conf;
      };
    };
  };
}
