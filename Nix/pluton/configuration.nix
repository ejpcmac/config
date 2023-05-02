################################################################################
##                                                                            ##
##                      System configuration for Pluton                       ##
##                                                                            ##
################################################################################

{ lib, ... }:

let
  inherit (lib) mkForce;
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
      location = "$company$";
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
  ##                              Boot process                              ##
  ############################################################################

  boot = {
    initrd = {
      luks.devices = {
        hdd.device = "/dev/sda2";
      };
    };

    zfs = {
      enableUnstable = true;
      requestEncryptionCredentials = false;
    };
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    zfs.autoScrub.interval = mkForce "Mon, 14:05";

    xserver = {
      dpi = 120;
      xautolock.enable = mkForce false;
      libinput.touchpad.naturalScrolling = false;
    };
  };

  ############################################################################
  ##                             Virtualisation                             ##
  ############################################################################

  virtualisation = {
    vmware.guest.enable = true;
  };
}
