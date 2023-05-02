################################################################################
##                                                                            ##
##                 Container configuration for ns.ejpcmac.net                 ##
##                                                                            ##
################################################################################

{ inputs, ... }:

{
  ############################################################################
  ##                        Container configuration                         ##
  ############################################################################

  containers.ns = {
    config = ./configuration.nix;
    specialArgs = { inherit inputs; };
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;
    hostAddress = "***[ REDACTED ]***";
    localAddress = "***[ REDACTED ]***";
  };

  ############################################################################
  ##                               Networking                               ##
  ############################################################################

  networking = {
    nat.internalInterfaces = [ "ve-ns" ];
  };
}
