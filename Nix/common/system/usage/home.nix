################################################################################
##                                                                            ##
##                      Configuration for home computing                      ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

{
  ############################################################################
  ##                               Networking                               ##
  ############################################################################

  networking = {
    # networkmanager.dispatcherScripts = [
    #   {
    #     # Automatically connect to the VPN.
    #     type = "basic";
    #     source = pkgs.writeText "vpn-up" ''
    #       conns=$(${pkgs.networkmanager}/bin/nmcli connection show --active \
    #                   | grep -e ethernet -e wifi \
    #                   | wc -l)

    #       if [ $conns -ge 1 ];
    #       then
    #         ${pkgs.networkmanager}/bin/nmcli connection up ejpcmac.net
    #       fi
    #     '';
    #   }
    # ];
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    wine

    # Applications
    asunder
    cantata
    easytag
    gimp
    inkscape
    k3b
    liferea
  ];

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    avahi = { enable = true; nssmdns = true; };
    usbmuxd.enable = true;
  };
}
