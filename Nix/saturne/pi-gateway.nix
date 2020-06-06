################################################################################
##                                                                            ##
##                     Configuration to make a Pi-Gateway                     ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  networking = {
    interfaces = {
      enp59s0u1u4 = {
        ipv4.addresses = [ { address = "192.168.10.254"; prefixLength = 24; } ];
      };
    };

    nat = {
      enable = true;
      externalInterface = "tap0";
      internalInterfaces = [ "enp59s0u1u4" ];
      extraCommands = ''
        iptables -t nat -A POSTROUTING -o enp59s0u1u4 -j MASQUERADE
        iptables -A FORWARD -i enp59s0u1u4 -o tap0 -j ACCEPT
        iptables -A FORWARD -i tap0 -o enp59s0u1u4 -j ACCEPT
      '';
    };
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "enp59s0u1u4" ];
    extraConfig = ''
      option subnet-mask 255.255.255.0;
      option broadcast-address 192.168.10.255;
      option routers 192.168.10.254;
      option domain-name-servers 1.1.1.1;
      subnet 192.168.10.0 netmask 255.255.255.0 {
        range 192.168.10.1 192.168.10.200;
      }
    '';
  };
}
