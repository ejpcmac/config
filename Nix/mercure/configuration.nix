################################################################################
##                                                                            ##
##                      System configuration for Mercure                      ##
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
      name = "mercure";
      machineId = "***[ REDACTED ]***";
      location = "caen";
    };

    profile = {
      type = [ "physical" "laptop" ];
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
        ollama.enable = true;
      };
    };
  };

  ############################################################################
  ##                              Boot process                              ##
  ############################################################################

  boot = {
    zfs.requestEncryptionCredentials = false;

    initrd = {
      luks.devices = {
        ssd = { device = "/dev/nvme0n1p2"; allowDiscards = true; };
      };
    };
  };

  ############################################################################
  ##                              File systems                              ##
  ############################################################################

  fileSystems = {
    "/persist/adjtime" = mkFs { volumePath = "/system/data/adjtime"; };
    "/persist/netrc" = mkFs { volumePath = "/system/data/netrc"; };
    "/persist/ssh" = mkFs { volumePath = "/system/data/ssh"; };
  };

  ############################################################################
  ##                              Persistence                               ##
  ############################################################################

  environment.etc = {
    # Persisted non-static files in /etc
    "adjtime".source = "/persist/adjtime/adjtime";
    "nix/netrc".source = "/persist/netrc/netrc";
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    throttled.enable = true;

    openssh = {
      enable = false;

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
      dpi = 160;
      xrandrHeads = [{ output = "eDP-1"; primary = true; }];
    };
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    # Garbage-collect during work hours.
    nh.clean.dates = "*-*~01 11:00";
  };
}
