################################################################################
##                                                                            ##
##                      System configuration for Helios                       ##
##                                                                            ##
################################################################################

{ inputs, pkgs, ... }:

{
  imports = [
    # Import my personal NixOS extension module.
    ../common/nixos

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

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
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    info = {
      name = "helios";
      location = "caen";
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
    };
  };

  ############################################################################
  ##                          Boot & File systems                           ##
  ############################################################################

  boot = {
    kernelModules = [ "coretemp" "nct6775" ];
    tmpOnTmpfs = true;
    zfs.requestEncryptionCredentials = false;

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
          hostKeys = [ "***[ REDACTED ]***" ];
        };

        postCommands = ''
          echo "cryptsetup-askpass" >> /root/.profile
        '';
      };
    };
  };

  # Set options for the legacy mountpoints.
  fileSystems = {
    "/".options = [ "noatime" ];
    "/boot".options = [ "nosuid" "nodev" "noexec" "noatime" ];
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
  ##                               Networking                               ##
  ############################################################################

  networking = {
    hostId = "9c20421a";
    useDHCP = true;

    # Glances: tcp/61208
    # Transmission: tcp/9091
    firewall.allowedTCPPorts = [ 9091 61208 ];

    interfaces = {
      enp3s0 = {
        ipv4.addresses = [{ address = "***[ REDACTED ]***"; prefixLength = 24; }];
      };
    };
  };

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

    zfs.autoSnapshot = {
      hourly = 48;
      monthly = 24;
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
}
