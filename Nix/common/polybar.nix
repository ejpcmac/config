####### Configuration for Polybar ##############################################
##                                                                            ##
## * One bar for the main monitor                                             ##
## * Integration with bspwm                                                   ##
## * ALSA volume, temperature, memory, CPU, network interfaces and date       ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault;
in

{
  services.polybar = {
    enable = true;

    package = pkgs.polybar.override {
      mpdSupport = true;
    };

    script = mkDefault "polybar main &";

    config = {
      colors = mkDefault {
        background = "#dd222222";
        background-alt = "#dd444444";
        foreground = "#dfdfdf";
        foreground-alt = "#555";
        primary = "#ffb52a";
        secondary = "#e60053";
        alert = "#bd2c40";
      };

      settings = {
        screenchange-reload = mkDefault true;
      };

      "bar/main" = mkDefault {
        fixed-center = false;

        width = "100%";
        height = 27;

        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        line-size = 3;
        line-color = "#f00";

        padding-left = 0;
        padding-right = 2;

        module-margin-left = 1;
        module-margin-right = 2;

        font-0 = "NotoSansMono Nerd Font:size=7.5:weight=bold;0";

        modules-left = "bspwm";
        modules-center = "mpd";
        modules-right = "emacs alsa temperature memory cpu battery wlan eth date";

        locale = "fr_FR.UTF-8";

        tray-position = "right";
        tray-padding = 2;

        wm-restack = "bspwm";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
      };

      "module/bspwm" = mkDefault {
        type = "internal/bspwm";

        format = "<label-state> <label-mode>";

        label-focused-background = "\${colors.background-alt}";
        label-focused-underline= "\${colors.primary}";
        label-focused-padding = 2;

        label-occupied-padding = 2;

        label-urgent-background = "\${colors.alert}";
        label-urgent-padding = 2;

        label-empty-foreground = "\${colors.foreground-alt}";
        label-empty-padding = 2;

        label-monocle = "";
        label-floating = "";
        label-pseudotiled = "P";
        label-locked = "";
        label-locked-foreground = "#bd2c40";
        label-sticky = "ﯻ";
        label-sticky-foreground = "#fba922";
        label-private = "";
        label-private-foreground = "#bd2c40";
      };

      "module/date" = mkDefault {
        type = "internal/date";

        label = "%date% %time%";
        date = "%Y-%m-%d";
        time = "%H:%M:%S";

        format-prefix = "";
        format-prefix-foreground = "\${colors.foreground-alt}";
        format-underline = "#0a6cf5";
      };

      "module/eth" = mkDefault {
        type = "internal/network";
        interface = "enp0s3";
        interval = 3;

        format-connected-underline = "#55aa55";
        format-connected-prefix = " ";
        format-connected-prefix-foreground = "\${colors.foreground-alt}";
        label-connected = "%local_ip%";

        format-disconnected = "";
        # format-disconnected = "<label-disconnected>";
        # format-disconnected-underline = "\${self.format-connected-underline}";
        # label-disconnected = "%ifname% disconnected";
        # label-disconnected-foreground = "\${colors.foreground-alt}";
      };

      "module/wlan" = mkDefault {
        type = "internal/network";
        interface = "net1";
        interval = 3;

        format-connected = "<ramp-signal> <label-connected>";
        format-connected-underline = "#9f78e1";
        label-connected = "%essid%";

        ramp-signal-0 = "";
        ramp-signal-1 = "";
        ramp-signal-2 = "";
        ramp-signal-3 = "";
        ramp-signal-4 = "";
        ramp-signal-foreground = "\${colors.foreground-alt}";
      };

      "module/battery" = mkDefault {
        type = "internal/battery";
        battery = "BAT0";
        adapter = "ADP1";
        full-at = 96;

        format-charging = "<animation-charging> <label-charging>";
        format-charging-underline = "#ffb52a";

        format-discharging = "<ramp-capacity> <label-discharging>";
        format-discharging-underline = "\${self.format-charging-underline}";

        format-full-prefix = " ";
        format-full-prefix-foreground = "\${colors.foreground-alt}";
        format-full-underline = "\${self.format-charging-underline}";

        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
        ramp-capacity-5 = "";
        ramp-capacity-6 = "";
        ramp-capacity-7 = "";
        ramp-capacity-8 = "";
        ramp-capacity-9 = "";
        ramp-capacity-foreground = "\${colors.foreground-alt}";

        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";
        animation-charging-5 = "";
        animation-charging-6 = "";
        animation-charging-7 = "";
        animation-charging-8 = "";
        animation-charging-9 = "";
        animation-charging-foreground = "\${colors.foreground-alt}";
        animation-charging-framerate = 750;
      };

      "module/cpu" = mkDefault {
        type = "internal/cpu";
        interval = 1;
        format-prefix = "﬙ ";
        format-prefix-foreground = "\${colors.foreground-alt}";
        format-underline = "#f90000";
        label = "%percentage-sum:3%%";
      };

      "module/memory" = mkDefault {
        type = "internal/memory";
        interval = "2";
        format-prefix = " ";
        format-prefix-foreground = "\${colors.foreground-alt}";
        format-underline = "#4bffdc";
        label = "%mb_used%";
      };

      "module/temperature" = mkDefault {
        type = "internal/temperature";
        thermal-zone = 0;
        warn-temperature = 60;

        format-underline = "#f50a4d";
        format-warn-underline = "\${self.format-underline}";

        label-warn-foreground = "\${colors.secondary}";
      };

      "module/alsa" = mkDefault {
        type = "internal/alsa";

        # master-soundcard = "default";
        # speaker-soundcard = "default";
        # headphone-soundcard = "default";

        mapped = true;
        interval = 5;

        format-volume = "<label-volume> <bar-volume>";
        label-volume = "墳 %percentage%%";

        format-muted-prefix = "婢 ";
        format-muted-foreground = "\${colors.foreground-alt}";
        label-muted = "sound muted";

        bar-volume-width = 10;
        bar-volume-foreground-0 = "#55aa55";
        bar-volume-foreground-1 = "#55aa55";
        bar-volume-foreground-2 = "#55aa55";
        bar-volume-foreground-3 = "#55aa55";
        bar-volume-foreground-4 = "#55aa55";
        bar-volume-foreground-5 = "#f5a70a";
        bar-volume-foreground-6 = "#ff5555";
        bar-volume-gradient = false;
        bar-volume-indicator = "|";
        bar-volume-indicator-font = 2;
        bar-volume-fill = "─";
        bar-volume-fill-font = 2;
        bar-volume-empty = "─";
        bar-volume-empty-font = 2;
        bar-volume-empty-foreground = "\${colors.foreground-alt}";
      };

      # TODO: Faire mieux.
      "module/emacs" = mkDefault {
        type = "custom/script";
        exec = "echo \"E\"";
        exec-if = "systemctl --user status emacs";
        interval = 5;
      };

      "module/mpd" = mkDefault {
        type = "internal/mpd";

        format-online = "ﱘ <label-song>  <icon-prev> <icon-stop> <toggle> <icon-next>";

        icon-prev = "玲";
        icon-stop = "";
        icon-play = "";
        icon-pause = "";
        icon-next = "怜";

        label-song-maxlen = 50;
        label-song-ellipsis = true;
      };
    };
  };
}
