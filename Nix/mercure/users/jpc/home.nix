################################################################################
##                                                                            ##
##                     Home configuration for jpc@mercure                     ##
##                                                                            ##
################################################################################

{ lib, pkgs, ... }:

let
  libjpc = pkgs.callPackage ../../../common/home-manager/jpc/lib { };
  inherit (lib) mkDefault mkForce;
  inherit (libjpc) link;

  mkBar = params: libjpc.mkBar ({
    modules-right = mkDefault "alsa temperature memory cpufreq cpu battery wlan eth eth-home date";
  } // params);
in

{
  imports = [
    # Configuration shared between hosts.
    ../../../common/home-manager/jpc/general.nix
    ../../../common/home-manager/jpc/type/laptop.nix
    ../../../common/home-manager/jpc/usage/workstation.nix
    ../../../common/home-manager/jpc/features/server-aliases.nix
    ../../../common/home-manager/jpc/features/zfs.nix
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    identity.email = mkForce "***[ REDACTED ]***";
  };

  ############################################################################
  ##                   Persistence & custom configuration                   ##
  ############################################################################

  home.file = {
    # Scripts
    ".local/bin/org-sync".source = ../../../common/scripts/org-sync;
    ".local/bin/switch-mode".source = ./scripts/switch-mode;
  };

  xdg.configFile = {
    # General persistence
    "nix".source = link "/home/jpc/.persist/nix";
    "teams-for-linux".source = link "/home/jpc/.persist/Teams";
  };

  xdg.dataFile = {
    # Wallpaper
    "wallpaper.jpg".source = ./res/rust-wallpaper.jpg;
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    polybar = {
      script = ''
        mode=laptop

        if [ -f $HOME/.local/share/mode ]; then
            mode=$(${pkgs.coreutils}/bin/cat $HOME/.local/share/mode)
        fi

        case $mode in
            docked-company)
                polybar laptop &
                polybar company-center &
                polybar company-right &
                ;;

            docked-home)
                polybar laptop &
                polybar home-center &
                polybar home-right &
                ;;

            docked-lisieux)
                polybar laptop &
                polybar lisieux-center &
                polybar lisieux-right &
                ;;

            presentation)
                polybar laptop &
                polybar projector &
                ;;

            *)
                polybar laptop &
        esac
      '';

      config = {
        "bar/laptop" = mkBar {
          monitor = "eDP-1";
          height = 36;
          font-size = 10;
          modules-right = "alsa backlight temperature memory cpufreq cpu battery wlan eth eth-home date tray";
        };

        "bar/company-center" = mkBar {
          monitor = "DP-1-1";
          height = 36;
          font-size = 10;
        };

        "bar/company-right" = mkBar {
          monitor = "DP-1-2";
          height = 36;
          font-size = 10;
        };

        "bar/home-center" = mkBar {
          monitor = "DP-1";
          height = 60;
          font-size = 15;
        };

        "bar/home-right" = mkBar {
          monitor = "HDMI-1";
          height = 60;
          font-size = 15;
        };

        "bar/lisieux-center" = mkBar {
          monitor = "HDMI-1";
          height = 36;
          font-size = 10;
        };

        "bar/lisieux-right" = mkBar {
          monitor = "DP-1";
          height = 36;
          font-size = 10;
        };

        "bar/projector" = mkBar {
          monitor = "HDMI-1";
          height = 36;
          font-size = 10;
          modules-right = "date";
        };

        "module/alsa".master-soundcard = "hw:0";
        "module/backlight".card = "intel_backlight";
        "module/temperature".hwmon-path = "/sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input";
        "module/wlan".interface = "wlp0s20f3";
        "module/eth".interface = "enp0s13f0u1u4";

        "module/battery" = {
          battery = "BAT0";
          adapter = "ADP1";
        };

        "module/eth-home" = {
          type = mkDefault "internal/network";
          interface = "enp0s20f0u1u2";

          format-connected-prefix = mkDefault "󰈀 ";
          format-connected-prefix-foreground = mkDefault "\${colors.icon}";
          format-connected-underline = mkDefault "#55aa55";

          label-connected = mkDefault "%local_ip% %netspeed:9%";
        };
      };
    };
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    termite.font = "DejaVu Sans Mono 8.5";
    git.package = pkgs.gitSVN;
    jujutsu.settings.user.email = mkForce "*** [REDACTED] ***";

    bspwm = {
      monitors = ''
        mode=laptop

        if [ -f $HOME/.local/share/mode ]; then
            mode=$(cat $HOME/.local/share/mode)
        fi

        case $mode in
            docked-company)
                bspc wm --reorder-monitors DP-1-1 DP-1-2 eDP-1
                bspc monitor DP-1-1 -d 1 2 3 4 5
                bspc monitor DP-1-2 -d 6 7 8 9 0
                bspc monitor eDP-1 -d $ = %
                ;;

            docked-home)
                bspc wm --reorder-monitors DP-1 HDMI-1 eDP-1
                bspc monitor DP-1 -d 1 2 3 4 5
                bspc monitor HDMI-1 -d 6 7 8 9 0
                bspc monitor eDP-1 -d $ = %
                ;;

            docked-lisieux)
                bspc wm --reorder-monitors HDMI-1 DP-1 eDP-1
                bspc monitor HDMI-1 -d 1 2 3 4 5
                bspc monitor DP-1 -d 6 7 8 9 0
                bspc monitor eDP-1 -d $ = %
                ;;

            presentation)
                bspc wm --reorder-monitors eDP-1 HDMI-1
                bspc monitor eDP-1 -d $ 1 2 3 4 5 6 7 8 9 0
                bspc monitor HDMI-1 -d = %
                ;;

            *)
                bspc monitor eDP-1 -d $ 1 2 3 4 5 6 7 8 9 0 = %
        esac
      '';
    };

    zsh = {
      shellAliases = {
        # Configuration Git et Jujutsu perso.
        gitp = "git config user.name \"Jean-Philippe Cugnet\" && git config user.email jean-philippe@cugnet.eu";
        tperso = "jj config set --repo user.email jean-philippe@cugnet.eu";

        # Mode management.
        sml = "switch-mode laptop";
        smdn = "switch-mode docked-company";
        smdh = "switch-mode docked-home";
        smdl = "switch-mode docked-lisieux";
        smp = "switch-mode presentation";
      };
    };
  };

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    # Utilities
    subversion

    # Applications
    remmina
  ];
}
