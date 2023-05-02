################################################################################
##                                                                            ##
##                      System configuration for Saturne                      ##
##                                                                            ##
################################################################################

{ config, inputs, lib, pkgs, system, ... }:

let
  inherit (lib) getName mkDefault optional;
  unstable = import inputs.nixpkgs-unstable { inherit system; };
  mkFs = pkgs.lib.confkit.mkFs config;
in

{
  imports = [
    # Import my personal NixOS extension module.
    ./nixos

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
      name = "saturne";
      machineId = "***[ REDACTED ]***";
    };

    profile = {
      type = [ "physical" "laptop" ];
      usage = [ "workstation" "home" ]
        ++ optional (config.specialisation != { }) "docked";
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

      custom.jpc = {
        docker.enable = true;
        serverMountpoints.enable = true;
      };

      custom.saturne = {
        tlp = {
          enable = true;
          powersave = mkDefault "on-battery";
        };

        # mpd.enable = true;
        # nix-serve.enable = true;
        # pi-gateway.enable = true;
        # webserver.enable = true;
      };
    };
  };

  ############################################################################
  ##                       Alternative configurations                       ##
  ############################################################################

  specialisation = {
    nomade = {
      inheritParentConfig = true;
      configuration = {
        system.nixos.tags = [ "nomade" ];
        confkit.profile.usage = [ "nomade" ];
      };
    };

    nomade-performance = {
      inheritParentConfig = true;
      configuration = {
        system.nixos.tags = [ "nomade" "performance" ];
        confkit = {
          profile.usage = [ "nomade" ];
          features.custom.saturne.tlp.powersave = "never";
        };
      };
    };

    nomade-powersave = {
      inheritParentConfig = true;
      configuration = {
        system.nixos.tags = [ "nomade" "powersave" ];
        confkit = {
          profile.usage = [ "nomade" ];
          features.custom.saturne.tlp.powersave = "always";
        };
      };
    };
  };

  ############################################################################
  ##                           Nix configuration                            ##
  ############################################################################

  nix = {
    # Only garbage-collect once a week to avoir rebuilding too often the
    # Daedalus IFD, and do it before update day.
    gc.dates = "Sat, 21:00";

    settings = {
      # Add the IOHK binary cache to build the Cardano platform more quickly.
      substituters = [ "https://hydra.iohk.io" ];
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
    };
  };

  ############################################################################
  ##                         nixpkgs configuration                          ##
  ############################################################################

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
      # TODO: Check why it is needed here despite also being in workstation*.
      "veracrypt"
      "nvidia-x11"
      "nvidia-settings"
      "Oracle_VM_VirtualBox_Extension_Pack"
    ];
  };

  ############################################################################
  ##                              Boot process                              ##
  ############################################################################

  boot = {
    supportedFilesystems = [ "btrfs" ];
    zfs.requestEncryptionCredentials = false;

    initrd = {
      luks.devices = {
        ssd1 = { device = "/dev/nvme0n1p2"; allowDiscards = true; };
        ssd2 = { device = "/dev/nvme1n1p2"; allowDiscards = true; };
      };
    };
  };

  ############################################################################
  ##                              File systems                              ##
  ############################################################################

  fileSystems = {
    "/persist/adjtime" = mkFs { volumePath = "/system/data/adjtime"; };
    "/var/lib/boltd" = mkFs { volumePath = "/system/data/boltd"; };
  };

  ############################################################################
  ##                              Persistence                               ##
  ############################################################################

  environment.etc = {
    # Persisted non-static files in /etc
    "adjtime".source = "/persist/adjtime/adjtime";
  };

  ############################################################################
  ##                                Hardware                                ##
  ############################################################################

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };

  # Tweak to get the touchpad working when waking up from sleep.
  powerManagement.resumeCommands = ''
    ${pkgs.kmod}/bin/rmmod i2c_hid
    ${pkgs.kmod}/bin/modprobe i2c_hid
  '';

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    hardware.bolt.enable = true;
    throttled.enable = true;

    printing.drivers = [ pkgs.epson-escpr ];
    udev.packages = [ unstable.mixxx ];
  };

  ############################################################################
  ##                             Virtualisation                             ##
  ############################################################################

  virtualisation = {
    virtualbox.host = { enable = true; enableExtensionPack = true; };
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    thunderbolt
  ];
}
