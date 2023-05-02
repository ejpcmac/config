################################################################################
##                                                                            ##
##                      Configuration for home computing                      ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (builtins.elem "home" config.confkit.profile.usage) {

    ########################################################################
    ##                             Networking                             ##
    ########################################################################

    networking = {
      networkmanager.dispatcherScripts = [
        {
          # Automatically connect to the VPN.
          type = "basic";
          source = pkgs.writeText "vpn-up" ''
            conns=$(${pkgs.networkmanager}/bin/nmcli connection show --active \
                        | grep -e ethernet -e wifi \
                        | wc -l)

            if [ $conns -ge 1 ];
            then
              ${pkgs.networkmanager}/bin/nmcli connection up ejpcmac.net
            fi
          '';
        }
      ];
    };

    ########################################################################
    ##                               Programs                             ##
    ########################################################################

    programs = {
      wireshark = { enable = true; package = pkgs.wireshark-qt; };
    };

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      avahi = { enable = true; nssmdns = true; };
    };

    ########################################################################
    ##                          System packages                           ##
    ########################################################################

    environment.systemPackages = with pkgs; [
      # Applications
      asunder
      cantata
      easytag
      gimp
      k3b
      soundkonverter
    ];
  };
}
