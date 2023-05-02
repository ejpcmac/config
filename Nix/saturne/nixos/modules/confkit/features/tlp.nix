################################################################################
##                                                                            ##
##                     Configuration for the tlp feature                      ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) enum;
  cfg = config.confkit.features.custom.saturne.tlp;
in

{
  options.confkit.features.custom.saturne.tlp = {
    enable = mkEnableOption "the TLP feature";

    powersave = mkOption {
      type = enum [ "never" "on-battery" "always" ];
      example = "powersave";
      description = "When to enable powersave mode";
    };
  };

  config = mkIf cfg.enable {

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      tlp = {
        enable = true;

        settings = {
          CPU_ENERGY_PERF_POLICY_ON_BAT =
            if cfg.powersave == "never"
            then "balance_power"
            else "power";

          CPU_ENERGY_PERF_POLICY_ON_AC =
            if cfg.powersave == "always"
            then "power"
            else "balance_performance";
        };
      };
    };
  };
}
