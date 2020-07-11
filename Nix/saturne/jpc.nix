################################################################################
##                                                                            ##
##                     Home configuration for jpc@saturne                     ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (pkgs) writeShellScript;
  confkit = import ../../confkit;

  ## Generates an email account.
  mkEmail = address: { primary ? false
                     , userName ? address
                     , imap ? defaultImap
                     , smtp ? defaultSmtp
                     , smtpAuth ? "login" }: {
    realName = "Jean-Philippe Cugnet";
    passwordCommand = "${pkgs.pass}/bin/pass courriel/${address}";

    inherit address userName primary imap smtp;

    mbsync = {
      enable = true;
      create = "both";
      expunge = "both";
      remove = "both";
    };

    msmtp.enable = true;
    msmtp.extraConfig.auth = smtpAuth;

    gpg = {
      encryptByDefault = true;
      signByDefault = true;
      key = "C350CCB299D730FDAF8C5B7AE847B871DADD49DF";
    };
  };

  ## Generates a Kermail account.
  mkKermail = userName: { primary ? false }:
    mkEmail "${userName}@***" {
      inherit userName primary;
      smtpAuth = "off";

      imap = {
        host = "imap.***";
        port = 993;
        tls = {
          enable = true;
          certificatesFile = ./imap.***.pem;
        };
      };

      smtp = {
        host = "smtp.***";
        port = 465;
        tls = {
          enable = true;
          certificatesFile = ./imap.***.pem;
        };
      };
    };

  defaultImap = {
    host = "imap.***";
    port = 143;
    tls = { enable = true; useStartTls = true; };
  };

  defaultSmtp = {
    host = "smtp.***";
    port = 587;
    tls = { enable = true; useStartTls = true; };
  };

  # Index the mailbox and update mu4e after running mbsync.
  mbsyncPostExec = writeShellScript "mbsync-post-exec" ''
    ${pkgs.emacs}/bin/emacsclient \
        --socket-name=/var/run/user/1000/emacs1000/server \
        --eval '(mu4e~proc-kill)' &&

    ${pkgs.mu}/bin/mu index --maildir=$HOME/Courriels &&

    ${pkgs.emacs}/bin/emacsclient \
        --socket-name=/var/run/user/1000/emacs1000/server \
        --eval '(mu4e-alert-enable-mode-line-display)'
  '';
in

{
  imports = [ ../common/jpc_workstation.nix ];

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    # Applications
    # saleae-logic
  ];

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  home.file = {
    # Scripts
    ".local/bin/docked".source = ./scripts/docked;
    ".local/bin/dosync".source = ./scripts/dosync;
    ".local/bin/format-ssd".source = ./scripts/format-ssd;
    ".local/bin/org-sync".source = ./scripts/org-sync;
    ".local/bin/toggle-touchpad".source = ./scripts/toggle-touchpad;
    ".local/bin/undocked".source = ./scripts/undocked;
    ".local/bin/zfs-clean-snapshots".source = ./scripts/zfs-clean-snapshots;

    # Zsh aliases and environments
    ".zsh/zfs.zsh".source = confkit.file "zsh/zfs.zsh";
  };

  xdg.configFile = {
    # TODO: Factorise sxhkd configurations and auto-create the link.
    "sxhkd/sxhkdrc_undocked".source = ../../desktop/sxhkdrc_undocked;
    "sxhkd/sxhkdrc_docked".source = ../../desktop/sxhkdrc_docked;
    "conky/conky.conf".source = ../../desktop/conky.conf;
    "conky/conky_functions.lua".source = ../../desktop/conky_functions.lua;
    "pms/pms.conf".source = confkit.file "misc/pms_bepo.conf";
  };

  ############################################################################
  ##                                Accounts                                ##
  ############################################################################

  accounts.email = {
    maildirBasePath = "${config.home.homeDirectory}/Courriels";

    accounts = {
      "***" = mkEmail "***" {};
      "***" = mkEmail "***" {};
      "***" = mkEmail "***" {};
      "***" = mkKermail "***" { primary = true; };
      "***" = mkKermail "***" {};
      "***" = mkKermail "***" {};
      "***" = mkKermail "***" {};
    };
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

  programs.pidgin = {
    enable = true;
    plugins = with pkgs; [ pidgin-otr ];
  };

  programs.mbsync = {
    enable = true;
  };

  programs.msmtp = {
    enable = true;
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
      # Specific ZFS aliases
      zly = "zfs list -o name,jpc:manager,readonly,compression,compressratio,used,usedbysnapshots,com.sun:auto-snapshot";
      wzly = "watch -n 1 zfs list -o name,jpc:manager,readonly,compression,compressratio,used,usedbysnapshots,com.sun:auto-snapshot";

      # External drive shortcuts
      umnt = "udisksctl mount -b /dev/sda1";
      uumnt = "udisksctl unmount -b /dev/sda1";
      upo = "udisksctl power-off -b /dev/sda";
      ueject = "uumnt && upo";

      # Network drives shortcuts
      lm = "mount | grep media";
      unet = "sudo systemctl stop 'media-*.mount'";

      # iPhone management
      mount-iphone = "ifuse ~/iPhone";
      unmount-iphone = "fusermount -u ~/iPhone";
      backup-iphone-photos = "rsync -a --progress ~/iPhone/DCIM/*/* ~/Photo/iPhone";

      # Performance
      cpt = "sudo cpupower frequency-set --max 2900MHz";
      cpt2 = "sudo cpupower frequency-set --max 1800MHz";
      cpt3 = "sudo cpupower frequency-set --max 1200MHz";
      cpt4 = "sudo cpupower frequency-set --max 800MHz";
      ucpt = "sudo cpupower frequency-set --max 4800MHz";
    };
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  # Compositor for windows transparency.
  services.compton = {
    enable = true;
  };

  # services.mbsync = {
  #   enable = true;
  #   frequency = "*:0/5";
  #   postExec = "${mbsyncPostExec}";
  # };

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
}
