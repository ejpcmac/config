################################################################################
##                                                                            ##
##                         Configuration for laptops                          ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

let
  inherit (lib) mkIf;
in

{
  config = mkIf (builtins.elem "laptop" config.confkit.profile.type) {

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      tlp.settings = {
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      };
    };
  };
}
