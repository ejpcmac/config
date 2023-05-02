################################################################################
##                                                                            ##
##                    Configuration for the nix-serve feature                 ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  mkFs = pkgs.lib.confkit.mkFs config;
  cfg = config.confkit.features.custom.saturne.nix-serve;
in

{
  options.confkit.features.custom.saturne.nix-serve = {
    enable = mkEnableOption "the nix-serve feature";
  };

  config = mkIf cfg.enable {

    ########################################################################
    ##                            File systems                            ##
    ########################################################################

    fileSystems = {
      "/persist/nix-serve" = mkFs { volumePath = "/system/data/nix-serve"; };
    };

    ########################################################################
    ##                            Persistence                             ##
    ########################################################################

    systemd.tmpfiles.rules = [
      "z /persist/nix-serve 755 nix-serve root - -"
    ];

    ########################################################################
    ##                             Networking                             ##
    ########################################################################

    networking = {
      firewall = {
        allowedTCPPorts = [ 6543 ];
      };
    };

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      nix-serve = {
        enable = true;
        port = 6543;
        secretKeyFile = "***[ REDACTED ]***";
      };
    };
  };
}
