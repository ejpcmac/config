################################################################################
##                                                                            ##
##                     Home configuration for jpc@saturne                     ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

{
  imports = [
    # Configuration shared between hosts.
    ../../../common/home-manager/jpc/general.nix
    ../../../common/home-manager/jpc/type/laptop.nix
    ../../../common/home-manager/jpc/usage/workstation.nix
    ../../../common/home-manager/jpc/usage/home.nix
    ../../../common/home-manager/jpc/features/repo-mirroring.nix
    ../../../common/home-manager/jpc/features/zfs.nix
    ../../../common/home-manager/jpc/location/kerguelen.nix
  ];

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  home.file = {
    # Scripts
    ".local/bin/docked".source = ./scripts/docked;
    ".local/bin/format-ssd".source = ./scripts/format-ssd;
    ".local/bin/org-sync".source = ./scripts/org-sync;
    ".local/bin/toggle-touchpad".source = ./scripts/toggle-touchpad;
    ".local/bin/undocked".source = ./scripts/undocked;
    ".local/bin/zfs-clean-snapshots".source = ./scripts/zfs-clean-snapshots;
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs.bspwm = {
    monitors = ''
      if [ -f $HOME/.local/share/is_docked ]; then
          bspc wm --reorder-monitors DP-1.1 DP-1.2 DP-0
          bspc monitor %DP-1.1 -d 1 2 3 4 5
          bspc monitor %DP-1.2 -d 6 7 8 9 0
          bspc monitor DP-0 -d $ = %
      else
          bspc monitor DP-0 -d $ 1 2 3 4 5 6 7 8 9 0 = %
      fi
    '';
  };

  programs.termite = {
    font = "Monospace 8.5";
  };

  programs.ssh = {
    enable = true;
    extraOptionOverrides.HostKeyAlgorithms = "ssh-rsa";
  };

  programs.zsh = {
    shellAliases = {
      # External drive shortcuts
      umnt = "udisksctl mount -b /dev/sda1";
      uumnt = "udisksctl unmount -b /dev/sda1";
      upo = "udisksctl power-off -b /dev/sda";
      ueject = "uumnt && upo";

      # Network drives shortcuts
      lm = "mount | grep media";
      unet = "sudo systemctl stop 'media-*.mount'";
    };
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  # Compositor for windows transparency.
  services.compton = {
    enable = true;
  };

  services.polybar = {
    script = "polybar laptop & polybar center & polybar right &";

    config = {
      "bar/laptop" = {
        monitor = "DP-0";
        fixed-center = false;

        width = "100%";
        height = 36;

        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        line-size = 3;
        line-color = "#f00";

        padding-left = 0;
        padding-right = 2;

        module-margin-left = 1;
        module-margin-right = 2;

        font-0 = "NotoSansMono Nerd Font:size=10:weight=bold;0";

        modules-left = "bspwm";
        modules-center = "mpd";
        modules-right = "alsa temperature memory cpu battery wlan eth date";

        locale = "fr_FR.UTF-8";

        tray-position = "right";
        tray-padding = 2;

        wm-restack = "bspwm";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
      };

      "bar/center" = {
        monitor = "DP-1.1";
        fixed-center = false;

        width = "100%";
        height = 32;

        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        line-size = 3;
        line-color = "#f00";

        padding-left = 0;
        padding-right = 2;

        module-margin-left = 1;
        module-margin-right = 2;

        font-0 = "NotoSansMono Nerd Font:size=8.5:weight=bold;0";

        modules-left = "bspwm";
        modules-center = "mpd";
        modules-right = "alsa temperature memory cpu battery wlan eth date";

        locale = "fr_FR.UTF-8";

        wm-restack = "bspwm";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
      };

      "bar/right" = {
        monitor = "DP-1.2";
        fixed-center = false;

        width = "100%";
        height = 32;

        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        line-size = 3;
        line-color = "#f00";

        padding-left = 0;
        padding-right = 2;

        module-margin-left = 1;
        module-margin-right = 2;

        font-0 = "NotoSansMono Nerd Font:size=8.5:weight=bold;0";

        modules-left = "bspwm";
        modules-center = "mpd";
        modules-right = "alsa temperature memory cpu battery wlan eth date";

        locale = "fr_FR.UTF-8";

        wm-restack = "bspwm";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
      };

      "module/alsa" = {
        type = "internal/alsa";

        # master-mixer = "PCM";
        master-soundcard = "hw:0";

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

      "module/mpd" = {
        type = "internal/mpd";
        # host = "helios";

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

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # Utilities
    unrar

    # Applications
    bitcoin
    dashpay
    kicad
    scribus
    thunderbird
    tor-browser-bundle-bin
  ];
}
