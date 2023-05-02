################################################################################
##                                                                            ##
##                      System configuration for Neptune                      ##
##                                                                            ##
################################################################################

{ config, inputs, pkgs, ... }:

let
  mkFs = pkgs.lib.confkit.mkFs config;
in

{
  # TODO: Remove this when on NixOS 23.05.
  disabledModules = [ "virtualisation/nixos-containers.nix" ];

  imports = [
    # TODO: Remove this when on NixOS 23.05.
    # HACK: Import nixos-containers from unstable to allow adding inputs to the
    # configurations.
    "${inputs.nixpkgs-unstable}/nixos/modules/virtualisation/nixos-containers.nix"

    # Import my personal NixOS extension module.
    ../common/nixos

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Configuration for the users.
    ./users/root
    ./users/jpc

    # Configuration for the containers.
    ../containers/ejpcmac.net/ns
    ../containers/ejpcmac.net/www
    # ...
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    info = {
      name = "neptune";
      machineId = "***[ REDACTED ]***";
      location = "neptune";
    };

    profile = {
      type = [ "physical" ];
      usage = [ "server" ];
    };

    features = {
      intel.enable = true;
      zfs.enable = true;

      bootloader = {
        enable = true;
        platform = "uefi";
        program = "systemd-boot";
      };

      fileSystems = {
        enable = true;
        fs = "zfs";
        rootOnTmpfs = true;
      };
    };
  };

  ############################################################################
  ##                              Boot process                              ##
  ############################################################################

  boot = {
    zfs.requestEncryptionCredentials = false;

    kernelParams = [
      "ip=***[ REDACTED ]***::***[ REDACTED ]***:255.255.255.0:neptune:eno3:off"
    ];

    initrd = {
      availableKernelModules = [ "ixgbe" ];

      luks.devices = {
        hdd1.device = "/dev/sda2";
        hdd2.device = "/dev/sdb2";
      };

      network = {
        enable = true;

        ssh = {
          enable = true;
          port = 2222;
          hostKeys = [ "***[ REDACTED ]***" ];
        };

        postCommands = ''
          echo "cryptsetup-askpass" >> /root/.profile
        '';
      };
    };
  };

  ############################################################################
  ##                              File systems                              ##
  ############################################################################

  fileSystems = {
    "/persist/dhparams" = mkFs { volumePath = "/system/data/dhparams"; };
    "/persist/letsencrypt" = mkFs { volumePath = "/system/data/letsencrypt"; };

    "/persist/acme/ejpcmac.net" = mkFs {
      volumePath = "/system/data/acme/ejpcmac.net";
    };
  };

  ############################################################################
  ##                               Networking                               ##
  ############################################################################

  networking = {
    domain = "ejpcmac.net";
    nameservers = [ "***[ REDACTED ]***" ];
    defaultGateway = "***[ REDACTED ]***";
    useDHCP = false;

    # Configure a network bridge for NixOS containers.
    bridges.br0.interfaces = [ "eno3" ];
    interfaces.br0.ipv4.addresses = [
      { address = "***[ REDACTED ]***"; prefixLength = 24; }
    ];

    # Configure a NAT for NixOS containers. Internal interfaces are specified in
    # each container declaration.
    nat = {
      enable = true;
      externalInterface = "br0";
    };
  };
}
