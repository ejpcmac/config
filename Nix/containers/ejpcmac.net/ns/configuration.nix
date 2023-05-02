################################################################################
##                                                                            ##
##                  System configuration for ns.ejpcmac.net                   ##
##                                                                            ##
################################################################################

{ pkgs, ... }:

{
  imports = [
    # Import my personal NixOS extension module.
    ../../../common/nixos

    # Configuration for the users.
    ../../../common/users/root/usage/container.nix
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    info = {
      name = "ns";
      machineId = "***[ REDACTED ]***";
      location = "neptune";
    };

    profile.type = [ "container" ];
  };

  ############################################################################
  ##                               Networking                               ##
  ############################################################################

  networking = {
    firewall.allowedUDPPorts = [ 53 ];
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    bind = {
      enable = true;

      cacheNetworks = [
        "***[ REDACTED ]***"
      ];

      extraOptions = ''
        dnssec-validation auto;
      '';
    };
  };
}
