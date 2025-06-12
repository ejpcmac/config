################################################################################
##                                                                            ##
##                      System configuration for Pluton                       ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkForce;
  mkFs = pkgs.lib.confkit.mkFs config;
in

{
  imports = [
    # Import my personal NixOS extension module.
    ../common/nixos

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Configuration for the users.
    ./users/root
    ./users/jpc
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    info = {
      name = "pluton";
      machineId = "***[ REDACTED ]***";
      location = "company";
    };

    profile = {
      type = [ "virtual" ];
      usage = [ "workstation" ];
    };

    features = {
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

      custom.jpc = {
        docker.enable = true;
      };
    };
  };

  ############################################################################
  ##                           Nix configuration                            ##
  ############################################################################

  nix = {
    # Garbage-collect during work hours.
    gc.dates = mkForce "*-*~01 11:00";
  };

  ############################################################################
  ##                              Boot process                              ##
  ############################################################################

  boot = {
    zfs.requestEncryptionCredentials = false;

    initrd = {
      luks.devices = {
        hdd.device = "/dev/sda2";
      };
    };
  };

  ############################################################################
  ##                              File systems                              ##
  ############################################################################

  fileSystems = {
    "/persist/netrc" = mkFs { volumePath = "/system/data/netrc"; };
    "/persist/ssh" = mkFs { volumePath = "/system/data/ssh"; };

    # "/media/host" = {
    #   device = "Partage";
    #   fsType = "vboxsf";
    #   options = [ "uid=1000" "gid=100" ];
    # };
  };

  ############################################################################
  ##                              Persistence                               ##
  ############################################################################

  environment.etc = {
    # Persisted non-static files in /etc
    "nix/netrc".source = "/persist/netrc/netrc";
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    libinput.touchpad.naturalScrolling = false;

    openssh = {
      enable = true;

      settings = {
        PasswordAuthentication = false;
      };

      hostKeys = [
        { path = "/persist/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
        { path = "/persist/ssh/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
      ];
    };

    zfs = {
      autoScrub.interval = mkForce "Mon 14:05";
      autoSnapshot.monthly = 6;
    };

    xserver = {
      dpi = 120;
      xautolock.enable = mkForce false;
    };
  };

  ############################################################################
  ##                             Virtualisation                             ##
  ############################################################################

  virtualisation = {
    vmware.guest.enable = true;
  };
}
