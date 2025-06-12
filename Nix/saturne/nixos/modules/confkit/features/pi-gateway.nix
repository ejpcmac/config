################################################################################
##                                                                            ##
##                  Configuration for the Pi-Gateway feature                  ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.confkit.features.custom.saturne.pi-gateway;
in

{
  options.confkit.features.custom.saturne.pi-gateway = {
    enable = mkEnableOption "the Pi-Gateway feature";
  };

  config = mkIf cfg.enable {
    networking = {
      interfaces = {
        enp58s0u1u4 = {
          ipv4.addresses = [{ address = "192.168.10.254"; prefixLength = 24; }];
        };
      };

      nat = {
        enable = true;
        externalInterface = "tap0";
        internalInterfaces = [ "enp58s0u1u4" ];
        extraCommands = ''
          iptables -t nat -A POSTROUTING -o enp59s0u1u4 -j MASQUERADE
          iptables -A FORWARD -i enp59s0u1u4 -o tap0 -j ACCEPT
          iptables -A FORWARD -i tap0 -o enp59s0u1u4 -j ACCEPT
        '';
      };
    };

    services.kea.dhcp4 = {
      enable = true;
      settings = {
        interfaces-config = {
          interfaces = [ "enp58s0u1u4" ];
        };

        subnet4 = [
          {
            subnet = "192.168.10.0/24";
            pools = [{ pool = "192.168.10.1 - 192.168.10.100"; }];
          }
        ];

        lease-database = {
          name = "/var/lib/kea/dhcp4.leases";
          persist = true;
          type = "memfile";
        };

        rebind-timer = 2000;
        renew-timer = 1000;
        valid-lifetime = 4000;
      };
    };
  };
}
