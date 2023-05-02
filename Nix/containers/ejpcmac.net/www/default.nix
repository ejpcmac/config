################################################################################
##                                                                            ##
##                Container configuration for www.ejpcmac.net                 ##
##                                                                            ##
################################################################################

{ config, inputs, pkgs, ... }:

let
  mkFs = pkgs.lib.confkit.mkFs config;
in

{
  ############################################################################
  ##                        Container configuration                         ##
  ############################################################################

  containers.www = {
    config = ./configuration.nix;
    specialArgs = { inherit inputs; };
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;
    hostAddress = "***[ REDACTED ]***";
    localAddress = "***[ REDACTED ]***";
    extraVeths.vb-www.hostBridge = "br0";

    bindMounts = {
      "/persist/sites" = {
        hostPath = "/persist/containers/www/sites";
        isReadOnly = true;
      };

      "/var/lib/acme/ejpcmac.net" = {
        hostPath = "/persist/acme/ejpcmac.net";
        isReadOnly = false;
      };
    };
  };

  ############################################################################
  ##                        Associated file systems                         ##
  ############################################################################

  fileSystems = {
    ########################################################################
    ##                              Websites                              ##
    ########################################################################

    "/persist/containers/www/sites/ejpcmac.net" = mkFs {
      volumePath = "/system/data/containers/www/sites/ejpcmac.net";
    };
  };
}
