################################################################################
##                                                                            ##
##                     Home configuration for jpc@saturne                     ##
##                                                                            ##
################################################################################

{ pkgs, ... }:

let
  libjpc = pkgs.callPackage ../../../common/home-manager/jpc/lib { };
  inherit (libjpc) link;
in

{
  imports = [
    # Configuration shared between hosts.
    ../../../common/home-manager/jpc/general.nix
    ../../../common/home-manager/jpc/type/laptop.nix
    ../../../common/home-manager/jpc/usage/workstation.nix
    ../../../common/home-manager/jpc/usage/home.nix
    ../../../common/home-manager/jpc/features/server-aliases.nix
    ../../../common/home-manager/jpc/features/zfs.nix
  ];

  ############################################################################
  ##                   Persistence & custom configuration                   ##
  ############################################################################

  home.file = {
    # Persistence
    ".bitcoin".source = link "/home/jpc/.persist/Crypto-monnaies/Bitcoin";
    ".bitmonero".source = link "/home/jpc/.persist/Crypto-monnaies/Monero/data";
    ".dashcore".source = link "/home/jpc/.persist/Crypto-monnaies/Dash";
    ".influx_history".source = link "/home/jpc/.persist/Histories/influx_history";
    ".vpn".source = link "/home/jpc/.persist/vpn";
    ".persist/Crypto-monnaies/Bitcoin/blocks".source = link "/data/Blockchains/Bitcoin";
    ".persist/Crypto-monnaies/Dash/blocks".source = link "/data/Blockchains/Dash";
    ".persist/Crypto-monnaies/Monero/data/lmdb".source = link "/data/Blockchains/Monero";

    # Cache persistence
    ".cache/monero-project".source = link "/home/jpc/.persist/Crypto-monnaies/Monero/cache";

    # Scripts
    ".local/bin/docked".source = ./scripts/docked;
    ".local/bin/format-ssd".source = ./scripts/format-ssd;
    ".local/bin/nixos-rebuild-switch-to-specialisation".source = ./scripts/nixos-rebuild-switch-to-specialisation;
    ".local/bin/org-sync".source = ../../../common/scripts/org-sync;
    ".local/bin/titan-backup".source = ./scripts/titan-backup;
    ".local/bin/toggle-brightness".source = ./scripts/toggle-brightness;
    ".local/bin/toggle-touchpad".source = ./scripts/toggle-touchpad;
    ".local/bin/undocked".source = ./scripts/undocked;
    ".local/bin/zfs-clean-snapshots".source = ../../../common/scripts/zfs-clean-snapshots;
  };

  xdg.configFile = {
    # Persistence
    "monero-project".source = link "/home/jpc/.persist/Crypto-monnaies/Monero/config";
  };

  xdg.dataFile = {
    # Persistence
    "Daedalus/mainnet".source = link "/home/jpc/.persist/Crypto-monnaies/Daedalus";
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    # Compositor for windows transparency.
    picom = {
      # FIXME: Disabled temporary due to a crash of X-server when using the
      # NVidia card on NixOS 22.11.
      enable = false;
    };

    polybar = {
      script = ''
        if [ -f $HOME/.local/share/is_docked ]; then
          polybar laptop &
          polybar center &
          polybar right &
        else
          polybar laptop &
        fi
      '';

      config = {
        "module/eth".interface = "enp10s0u1u3u3";
        "module/wlan".interface = "wlp0s20f3";
        "module/temperature".hwmon-path = "/sys/devices/platform/coretemp.0/hwmon/hwmon6/temp1_input";
        "module/alsa".master-soundcard = "hw:0";

        "module/battery" = {
          battery = "BAT0";
          adapter = "ADP1";
        };

        "bar/laptop" = {
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
          modules-right = "alsa backlight temperature memory cpufreq cpu battery wlan eth date";

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
          height = 60;

          background = "\${colors.background}";
          foreground = "\${colors.foreground}";

          line-size = 3;
          line-color = "#f00";

          padding-left = 0;
          padding-right = 2;

          module-margin-left = 1;
          module-margin-right = 2;

          font-0 = "NotoSansMono Nerd Font:size=15:weight=bold;0";

          modules-left = "bspwm";
          modules-right = "alsa temperature memory cpufreq cpu battery wlan eth date";

          locale = "fr_FR.UTF-8";

          wm-restack = "bspwm";

          cursor-click = "pointer";
          cursor-scroll = "ns-resize";
        };

        "bar/right" = {
          monitor = "DP-1.2";
          fixed-center = false;

          width = "100%";
          height = 60;

          background = "\${colors.background}";
          foreground = "\${colors.foreground}";

          line-size = 3;
          line-color = "#f00";

          padding-left = 0;
          padding-right = 2;

          module-margin-left = 1;
          module-margin-right = 2;

          font-0 = "NotoSansMono Nerd Font:size=15:weight=bold;0";

          modules-left = "bspwm";
          modules-right = "alsa temperature memory cpufreq cpu battery wlan eth date";

          locale = "fr_FR.UTF-8";

          wm-restack = "bspwm";

          cursor-click = "pointer";
          cursor-scroll = "ns-resize";
        };
      };
    };
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    termite.font = "DejaVu Sans Mono 8.5";

    zsh = {
      shellAliases = {
        # Specialisation management.
        nospe = "sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch";
        spe-nomade = "sudo /nix/var/nix/profiles/system/specialisation/nomade/bin/switch-to-configuration switch";
        spe-nomade-performance = "sudo /nix/var/nix/profiles/system/specialisation/nomade-performance/bin/switch-to-configuration switch";
        spe-nomade-powersave = "sudo /nix/var/nix/profiles/system/specialisation/nomade-powersave/bin/switch-to-configuration switch";
        snors = "sudo nixos-rebuild-switch-to-specialisation";

        # External drive shortcuts
        umnt = "udisksctl mount -b /dev/sda1";
        uumnt = "udisksctl unmount -b /dev/sda1";
        upo = "udisksctl power-off -b /dev/sda";
        upob = "udisksctl power-off -b /dev/sdb";
        ueject = "uumnt && upo";

        mount-titan = ''
          sudo udevadm trigger && \
          sudo cryptsetup open --allow-discards /dev/sda2 titan && \
          sudo zpool import titan -R /titan
        '';

        unmount-titan = ''
          sudo zpool export titan && \
          sudo cryptsetup close titan && \
          udisksctl power-off -b /dev/sda
        '';
      };
    };
  };

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    # Utilities
    # influxdb

    # Applications
    bitcoin
    # daedalus
    gnucash
    monero-gui
    tdesktop
    # tor-browser-bundle-bin
  ];
}
