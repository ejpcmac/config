################################################################################
##                                                                            ##
##                      System configuration for Saturne                      ##
##                                                                            ##
################################################################################

{ config, inputs, lib, pkgs, ... }:

let
  inherit (lib) getName mkIf optional;
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
      location = "caen";
    };

    profile = {
      type = [ "physical" "laptop" ]
        ++ optional (config.specialisation != { }) "monitors-intel+gpu";
      usage = [ "workstation" ]
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

        ollama = {
          enable = true;
          acceleration = "cuda";
        };
      };

      custom.saturne = {
        nvidia-gpu = mkIf (config.specialisation != { }) {
          enable = true;
          mode = "sync";
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
    docked-offload = {
      inheritParentConfig = true;
      configuration = {
        environment.etc."specialisation".text = "docked-offload";
        system.nixos.label = "docked-offload-${config.system.nixos.version}";
        confkit = {
          profile = {
            type = [ "monitors-intel" ];
            usage = [ "docked" ];
          };

          features.custom.saturne.nvidia-gpu = {
            enable = true;
            mode = "offload";
          };
        };
      };
    };

    undocked = {
      inheritParentConfig = true;
      configuration = {
        environment.etc."specialisation".text = "undocked";
        system.nixos.label = "undocked-${config.system.nixos.version}";
        confkit = {
          profile = {
            type = [ "monitors-intel" ];
            usage = [ "undocked" ];
          };

          features.custom.saturne.nvidia-gpu = {
            enable = true;
            enableMonitors = false;
            mode = "offload";
          };
        };
      };
    };

    undocked-gpu = {
      inheritParentConfig = true;
      configuration = {
        environment.etc."specialisation".text = "undocked-gpu";
        system.nixos.label = "undocked-gpu-${config.system.nixos.version}";
        confkit = {
          profile = {
            type = [ "monitors-intel+gpu" ];
            usage = [ "undocked" ];
          };

          features.custom.saturne.nvidia-gpu = {
            enable = true;
            mode = "sync";
          };
        };
      };
    };

    # undocked-intel = {
    #   inheritParentConfig = true;
    #   configuration = {
    #     environment.etc."specialisation".text = "undocked-intel";
    #     system.nixos.label = "undocked-intel-${config.system.nixos.version}";
    #     confkit.profile = {
    #       type = [ "monitors-intel" ];
    #       usage = [ "undocked" ];
    #     };
    #   };
    # };

    # docked-nvidia = {
    #   inheritParentConfig = true;
    #   configuration = {
    #     environment.etc."specialisation".text = "docked-nvidia";
    #     system.nixos.label = "docked-nvidia-${config.system.nixos.version}";
    #     confkit = {
    #       profile = {
    #         type = [ "monitors-nvidia" ];
    #         usage = [ "docked" ];
    #       };

    #       features.custom.saturne.nvidia-gpu = {
    #         enable = true;
    #         mode = "discrete";
    #       };
    #     };
    #   };
    # };
  };

  ############################################################################
  ##                         nixpkgs configuration                          ##
  ############################################################################

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
      # epkowa
      "iscan"
      "iscan-data"
      "iscan-gt"
      "iscan-gt-f720-bundle"
      "iscan-gt-s600-bundle"
      "iscan-gt-s650-bundle"
      "iscan-gt-s80-bundle"
      "iscan-gt-x750-bundle"
      "iscan-gt-x770-bundle"
      "iscan-gt-x820-bundle"
      "iscan-nt-bundle"
      "iscan-perfection-v550-bundle"
      "iscan-v330-bundle"
      "iscan-v370-bundle"

      # ollama
      "cuda_cccl"
      "cuda_cudart"
      "cuda_cudart"
      "cuda_nvcc"
      "libcublas"

      # Nvidia X11
      "nvidia-settings"
      "nvidia-x11"

      # nvtop
      "cuda-merged"
      "cuda_cuobjdump"
      "cuda_cupti"
      "cuda_cuxxfilt"
      "cuda_gdb"
      "cuda_nvdisasm"
      "cuda_nvml_dev"
      "cuda_nvprune"
      "cuda_nvrtc"
      "cuda_nvtx"
      "cuda_profiler_api"
      "cuda_sanitizer_api"
      "libcufft"
      "libcurand"
      "libcusolver"
      "libcusparse"
      "libnpp"
      "libnvjitlink"
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
    graphics.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    sane = {
      enable = true;
      extraBackends = [ pkgs.epkowa ];
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
    # avahi = { enable = true; nssmdns4 = true; };
    hardware.bolt.enable = true;
    throttled.enable = true;

    printing.drivers = [ pkgs.epson-escpr ];
    udev.packages = [ pkgs.mixxx ];
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    wireshark = { enable = true; package = pkgs.wireshark-qt; };
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    thunderbolt
    nvtopPackages.full
  ];
}
