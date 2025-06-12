################################################################################
##                                                                            ##
##                      Configuration for the Nvidia GPU                      ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.confkit.features.custom.saturne.nvidia-gpu;

  nvidia-smi = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi";
in

{
  options.confkit.features.custom.saturne.nvidia-gpu = {
    enable = mkEnableOption "the Nvidia GPU";

    mode = mkOption {
      type = types.enum [ "discrete" "offload" "sync" ];
      example = "offload";
      description = "Which mode to use the Nvidia GPU in.";
    };

    enableMonitors = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "Whether to enable access to monitors connected to the Nvidia GPU.";
    };
  };

  config = mkIf cfg.enable {

    ########################################################################
    ##                           Kernel modules                           ##
    ########################################################################

    # NOTE: Ensure the X server is not trying to use the Nvidia GPU when
    # monitors connected to the Nvidia card are not enabled.
    boot.blacklistedKernelModules = mkIf (!cfg.enableMonitors) [ "nvidia_drm" ];

    ########################################################################
    ##                              Hardware                              ##
    ########################################################################

    hardware = {
      nvidia = {
        open = false;

        powerManagement = {
          enable = true;
          finegrained = cfg.mode == "offload";
        };

        prime = mkIf (cfg.mode != "discrete") {
          sync.enable = cfg.mode == "sync";

          offload = mkIf (cfg.mode == "offload") {
            enable = true;
            enableOffloadCmd = true;
          };

          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
    };

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      xserver = {
        videoDrivers = [ "nvidia" ];

        screenSection = mkIf (cfg.mode != "offload") ''
          Option "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
          Option "AllowIndirectGLXProtocol" "off"
          Option "TripleBuffer" "on"
        '';
      };
    };

    ########################################################################
    ##                         Home configuration                         ##
    ########################################################################

    home-manager.users.jpc = {
      services = {
        polybar = {
          config = {
            "module/gpu" = {
              type = "custom/script";
              interval = 1;

              format-prefix = "󰍹 ";
              format-prefix-foreground = "\${colors.icon}";
              format-underline = "#f90000";

              exec = "printf '%2s%%' \"$("
                + "${nvidia-smi} --query-gpu=utilization.gpu --format=csv,noheader,nounits"
                + ")\"";
            };

            "module/gpumem" = {
              type = "custom/script";
              interval = 2;

              format-prefix = "󰍹 ";
              format-prefix-foreground = "\${colors.icon}";
              format-underline = "#4bffdc";

              exec = "printf '%4s MiB' \"$("
                + "${nvidia-smi} --query-gpu=memory.used --format=csv,noheader,nounits"
                + ")\"";
            };
          };
        };
      };
    };
  };
}
