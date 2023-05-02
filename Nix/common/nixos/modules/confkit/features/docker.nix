################################################################################
##                                                                            ##
##                          Configuration for Docker                          ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  mkFs = pkgs.lib.confkit.mkFs config;
  cfg = config.confkit.features.custom.jpc.docker;
in

{
  options.confkit.features.custom.jpc.docker = {
    enable = mkEnableOption "the configuration for docker";
  };

  config = mkIf cfg.enable {

    ########################################################################
    ##                            File systems                            ##
    ########################################################################

    fileSystems = {
      "/persist/docker/config" = mkFs {
        volumePath = "/system/data/docker/config";
      };

      "/persist/docker/containerd" = mkFs {
        volumePath = "/system/data/docker/containerd";
      };

      "/persist/docker/state" = mkFs {
        volumePath = "/system/data/docker/state";
      };
    };

    ########################################################################
    ##                            Persistence                             ##
    ########################################################################

    environment.etc = {
      "docker".source = "/persist/docker/config";
    };

    systemd.tmpfiles.rules = [
      "z /persist/docker/state 711 root root - -"
      "z /persist/docker/containerd 711 root root - -"
      "L+ /var/lib/docker - - - - /persist/docker/state"
      "L+ /opt/containerd - - - - /persist/docker/containerd"
    ];

    ########################################################################
    ##                           Virtualisation                           ##
    ########################################################################

    virtualisation = {
      docker.enable = true;
    };
  };
}
