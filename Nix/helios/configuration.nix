################################################################################
##                                                                            ##
##                      System configuration for Helios                       ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03";  # Did you read the comment?

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Configuration shared between hosts.
    ../common/nixos/general.nix
    ../common/nixos/type/physical.nix
    ../common/nixos/usage/server.nix
    ../common/nixos/features/systemd-boot.nix
    ../common/nixos/features/zfs.nix
    ../common/nixos/location/lisieux.nix

    # Local features.
    ./features/mpd.nix
    ./features/samba.nix

    # Configuration for the users.
    ./users/root
    ./users/jpc

    # Configuration for the groups.
    ./groups
  ];

  ############################################################################
  ##                          Boot & File systems                           ##
  ############################################################################

  boot = {
    kernelModules = [ "coretemp" "nct6775" ];
    # TODO: Remove when I have physical access to the machine.
    supportedFilesystems = [ "zfs" ];
    tmpOnTmpfs = true;

    initrd = {
      availableKernelModules = [ "e1000e" ];

      luks.devices = {
        ssd-log = { device = "/dev/nvme0n1p2"; allowDiscards = true; };
        ssd-cache = { device = "/dev/nvme0n1p3"; allowDiscards = true; };
        hdd1 = { device = "/dev/sda"; };
        hdd2 = { device = "/dev/sdb"; };
        hdd3 = { device = "/dev/sdc"; };
        hdd4 = { device = "/dev/sdd"; };
        hdd5 = { device = "/dev/sde"; };
        hdd6 = { device = "/dev/sdf"; };
      };

      network = {
        enable = true;

        ssh = {
          enable = true;
          port = 2222;
          hostRSAKey = ./res/initrd-ssh-key;

          authorizedKeys = [
            # REDACTED.
          ];
        };

        postCommands = ''
          echo "cryptsetup-askpass" >> /root/.profile
        '';
      };
    };

    zfs.requestEncryptionCredentials = false;
  };

  # Set options for the legacy mountpoints.
  fileSystems = {
    "/".options = [ "noatime" ];
    "/boot".options = [ "nosuid" "nodev" "noexec" "noatime" ];
    "/config".options = [ "nosuid" "nodev" "noexec" "noatime" ];
    "/etc".options = [ "nosuid" "nodev" "noatime" ];
    "/root".options = [ "nosuid" "nodev" "noatime" ];
    "/var".options = [ "nosuid" "nodev" "noexec" ];
    "/var/cache".options = [ "nosuid" "nodev" "noexec" ];
    "/var/db".options = [ "nosuid" "nodev" "noexec" ];
    "/var/empty".options = [ "nosuid" "nodev" "noexec" "noatime" ];
    "/var/log".options = [ "nosuid" "nodev" "noexec" ];
    "/var/tmp".options = [ "nosuid" "nodev" "noexec" ];
  };

  ############################################################################
  ##                         General configuration                          ##
  ############################################################################

  networking = {
    hostName = "helios";
    hostId = "9c20421a";
    useDHCP = true;

    # Glances: tcp/61208
    # Transmission: tcp/9091
    firewall.allowedTCPPorts = [ 9091 61208 ];

    interfaces = {
      enp3s0 = {
        ipv4.addresses = [ { address = "192.168.15.1"; prefixLength = 24; } ];
      };
    };
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    hddtemp
    ntfs3g
  ];

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    dhcpd4 = {
      enable = true;
      interfaces = [ "enp3s0" ];
      extraConfig = ''
        option subnet-mask 255.255.255.0;
        option broadcast-address 192.168.15.255;
        subnet 192.168.15.0 netmask 255.255.255.0 {
          range 192.168.15.100 192.168.15.200;
        }
      '';
    };

    zfs = {
      autoScrub.interval = "Sun, 10:00";

      autoSnapshot = {
        hourly = 48;
        monthly = 24;
      };
    };
  };
}
