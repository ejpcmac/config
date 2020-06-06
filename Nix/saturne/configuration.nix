################################################################################
##                                                                            ##
##                      System configuration for Saturne                      ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  jpc = import <nixpkgs-jpc> { inherit pkgs; };
in

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09";  # Did you read the comment?

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix

    # Configuration shared between hosts.
    ../common/configuration.nix

    # Configuration to make a Pi-Gateway
    # ./pi-gateway.nix
  ];

  # Nix configuration for offline mode.
  nix = {
    binaryCaches = lib.mkForce [ "file:///data/Mirroirs/nixpkgs/cache" ];
    gc.automatic = false;
  };

  ############################################################################
  ##                          Boot & File systems                           ##
  ############################################################################

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ exfat-nofuse ];
    kernelModules = [ "exfat" ];
    supportedFilesystems = [ "zfs" ];
    tmpOnTmpfs = true;

    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      timeout = 1;
    };

    initrd = {
      luks.devices = {
        ssd1 = { device = "/dev/nvme0n1p2"; allowDiscards = true; };
        ssd2 = { device = "/dev/nvme1n1p2"; allowDiscards = true; };
      };
    };

    zfs.requestEncryptionCredentials = false;
  };

  fileSystems = {
    # Set options for the legacy mountpoints.
    "/".options = [ "noatime" ];
    "/boot".options = [ "nosuid" "nodev" "noexec" "noatime" ];
    "/etc".options = [ "nosuid" "nodev" "noatime" ];
    "/root".options = [ "nosuid" "nodev" "noatime" ];
    "/var".options = [ "nosuid" "nodev" "noexec" ];
    "/var/cache".options = [ "nosuid" "nodev" "noexec" ];
    "/var/db".options = [ "nosuid" "nodev" "noexec" ];
    "/var/empty".options = [ "nosuid" "nodev" "noexec" "noatime" ];
    "/var/log".options = [ "nosuid" "nodev" "noexec" ];
    "/var/tmp".options = [ "nosuid" "nodev" ];
  };

  ############################################################################
  ##                                Hardware                                ##
  ############################################################################

  hardware = {
    cpu.intel.updateMicrocode = true;
  };

  ############################################################################
  ##                         General configuration                          ##
  ############################################################################

  networking = {
    hostName = "saturne";
    hostId = "66f21a93";
    search = [ "kerguelen.ipev.fr" ];

    firewall = {
      # Share websites and mirrors.
      allowedTCPPorts = [ 80 6543 ];
    };

    hosts = {
      # Local web servers
      "127.0.0.1" = [
        "localhost"
        "saturne"
        "crates.saturne"
        "hex.saturne"
        "nix.saturne"
        "dev.jpc.photos"
        "dev.bark-artwork.com"
      ];
    };

    networkmanager = {
      enable = true;
      packages = with pkgs; [
        networkmanager-openvpn
      ];

      # dispatcherScripts = [
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
  };

  powerManagement.resumeCommands = ''
    ${pkgs.kmod}/bin/rmmod i2c_hid
    ${pkgs.kmod}/bin/modprobe i2c_hid
  '';

  ############################################################################
  ##                              Environment                               ##
  ############################################################################

  environment.variables = {
    # Use the local mirrors.
    HEX_MIRROR_URL = "http://hex.saturne/repos/hexpm_mirror";
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; with jpc; [
    # Utilities
    cifs-utils
    linuxPackages.cpupower
    powertop
    thunderbolt
    syncoid
    wine

    # Applications
    asunder
    bitcoin
    cantata
    dashpay
    darktable
    easytag
    firefox
    gimp
    ifuse
    inkscape
    k3b
    kicad
    liferea
    scribus
    signal-desktop
    stellarium
    thunderbird
    tor-browser-bundle-bin
    unrar
  ];

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    avahi = { enable = true; nssmdns = true; };
    hardware.bolt.enable = true;
    throttled.enable = true;
    tlp.enable = true;
    usbmuxd.enable = true;

    printing.drivers = [ pkgs.epson-escpr ];

    httpd = {
      enable = true;
      enablePHP = true;
      adminAddr = "jpc+saturne@ejpcmac.net";

      virtualHosts = [
        {
          hostName = "localhost";
          documentRoot = "/var/lib/www/localhost";
        }

        {
          hostName = "nix.saturne";
          documentRoot = "/data/Mirroirs/nixpkgs";
        }

        {
          hostName = "crates.saturne";
          documentRoot = "/data/Mirroirs/crates.io";
        }

        {
          hostName = "hex.saturne";
          documentRoot = "/data/Mirroirs/hex.pm";
        }

        {
          hostName = "dev.jpc.photos";
          documentRoot = "/var/lib/www/jpc_photos";
          extraConfig = ''
            <Directory "/var/lib/www/jpc_photos">
              DirectoryIndex index.html index.php
              AllowOverride All
            </Directory>
          '';
        }

        {
          hostName = "dev.bark-artwork.com";
          documentRoot = "/var/lib/www/bark-artwork.com";
          extraConfig = ''
            <Directory "/var/lib/www/bark-artwork.com">
              DirectoryIndex index.html index.php
              AllowOverride All
            </Directory>
          '';
        }
      ];
    };

    mpd = {
      enable = true;
      musicDirectory = "/data/Musique";
      extraConfig = builtins.readFile ./mpd/mpd.conf;
    };

    nix-serve = {
      enable = true;
      port = 6543;
      secretKeyFile = "/var/lib/nix-serve/cache-priv-key.pem";
    };

    smartd = {
      enable = true;
    };

    xserver = {
      dpi = 141;
      videoDrivers = [ "nvidia" ];
      xrandrHeads = [ { output = "DP-0"; primary = true; } ];
    };

    zfs = {
      autoSnapshot = {
        enable = true;
        frequent = 4;
        hourly = 24;
        daily = 7;
        weekly = 4;
        monthly = 24;
      };

      autoScrub = {
        enable = true;
        interval = "Sun, 13:00";
      };
    };
  };

  ############################################################################
  ##                             Virtualisation                             ##
  ############################################################################

  virtualisation = {
    docker.enable = true;
    virtualbox.host = { enable = true; enableExtensionPack = true; };
  };
}
