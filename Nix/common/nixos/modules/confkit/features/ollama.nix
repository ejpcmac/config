################################################################################
##                                                                            ##
##                    Configuration for the ollama feature                    ##
##                                                                            ##
################################################################################

{ config, lib, options, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkForce mkIf;
  cfg = config.confkit.features.custom.jpc.ollama;
  mkFs = pkgs.lib.confkit.mkFs config;
in

{
  options.confkit.features.custom.jpc.ollama = {
    enable = mkEnableOption "the ollama feature";
    acceleration = options.services.ollama.acceleration;
  };

  config = mkIf cfg.enable {

    ########################################################################
    ##                            File systems                            ##
    ########################################################################

    fileSystems = {
      "/persist/ollama" = mkFs { volumePath = "/system/data/ollama"; };
    };

    ########################################################################
    ##                            Persistence                             ##
    ########################################################################

    # Ensure the UID/GID are stable.
    users = {
      users.ollama.uid = 800;
      groups.ollama.gid = 800;
    };

    systemd.tmpfiles.rules = [
      "z /persist/ollama 700 ollama ollama - -"
    ];

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      ollama = {
        enable = true;
        home = "/persist/ollama";
        user = "ollama";
        acceleration = cfg.acceleration;
      };
    };

    systemd.services = {
      # Do not automatically start ollama on boot.
      ollama.wantedBy = mkForce [ ];
    };
  };
}
