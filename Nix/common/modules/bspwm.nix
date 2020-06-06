{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.programs.bspwm;
in

{
  options.programs.bspwm = {
    enable = mkEnableOption "bspwm";

    monitors = mkOption {
      type = types.str;
      description = "A list a commands to configure the monitors.";
      default = ''
        bspc monitor -d I II III IV V VI VII VIII IX X
      '';
    };

    initScript = mkOption {
      type = types.str;
      description = "Init script for other desktop-related services.";
      default = ''
        if [ $(ps x | grep sxhkd | grep -v grep | wc -l) -eq 0 ]; then
            sxhkd &
        fi
      '';
    };

    extraConfig = mkOption {
      type = types.str;
      description = "Extra bspwm configuration options.";
      default = "";
      example = ''
        bspc config border_width  2
        bspc config border_gap    12
        bspc config split_ration  0.50
      '';
    };

    extraRules = mkOption {
      type = types.str;
      description = "Extra rules for bspwm.";
      default = "";
      example = ''
        bspc rule -a Gimp desktop='^8' state=floating follow=on
      '';
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."bspwm/bspwmrc" = {
      executable = true;
      text = ''
      #!/bin/sh

      ${cfg.monitors}
      ${cfg.initScript}
      ${cfg.extraConfig}
      ${cfg.extraRules}
      '';
    };
  };
}
