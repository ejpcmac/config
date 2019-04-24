##
## Home configuration for jpc@eft-jpc
##
## NOTE: This host is a non-NixOS Linux, hence much more packages installed in
## here and specific options.
##

{ config, lib, pkgs, ... }:

with lib;

let
  inherit (builtins) readFile;
  confkit = import ../../confkit;

  pms = pkgs.callPackage ../common/pkgs/pms.nix {};
in

{
  imports = [
    ../common/home.nix
    ../common/bspwm.nix
    ../common/polybar.nix
    ../common/termite.nix
  ];

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    conky
    curl
    dcfldd
    docker
    docker_compose
    emv
    feh
    git-lfs
    gnupg
    htop
    iftop
    imagemagick
    maim
    mosh
    mpc_cli
    nix-prefetch-github
    openssh
    pandoc
    pms
    pqiv
    glibcLocales
    ranger
    rsync
    saleae-logic
    sxhkd
    trash-cli
    tokei
    wget
    xz
    zathura

    signal-desktop
    texlive.combined.scheme-medium
  ];

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  home.file = {
    # eft-jpc-specific config
    ".zsh/fedora.zsh".source = confkit.file "zsh/fedora.zsh";
    ".zsh/gpg-agent.zsh".source = confkit.file "zsh/gpg-agent.zsh";
  };

  xdg.configFile = {
    "sxhkd/sxhkdrc".source = ../../desktop/sxhkdrc;
    "conky/conky.conf".source = ../../desktop/conky.conf;
    "conky/conky_functions.lua".source = ../../desktop/conky_functions.lua;
    "pms/pms.conf".source = confkit.file "misc/pms_bepo.conf";
    "ranger/rc.conf".source = confkit.file "ranger/rc.conf";
    "zathura/zathurarc".source = confkit.file "misc/zathurarc_bepo";
  };

  home.sessionVariables = {
    # Set $LOCALE_ARCHIVE to avoid encoding errors.
    LOCALE_ARCHIVE = "$HOME/.nix-profile/lib/locale/locale-archive";

    # Set $TMDIR so that it is the same inside and outside Nix shells.
    TMPDIR = "/var/run/user/$UID";
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs.bspwm = {
    enable = true;

    monitors = ''
      xrandr --output HDMI-1 --primary
      bspc wm --reorder-monitors HDMI-1 VGA-1
      bspc monitor HDMI-1 -d 1 2 3 4 5 6 7 8 9 0
      bspc monitor VGA-1 -d $ = %
    '';
  };

  # Enable Emacs here since the system configuration is not handled.
  programs.emacs.enable = true;

  # Specific Git configuration
  programs.git = {
    userEmail = mkForce "***";
    extraConfig.credential.helper = "store";
  };

  programs.rofi = {
    enable = true;
  };

  programs.zsh = {
    initExtra = mkForce (''
      export RANGER_LOAD_DEFAULT_RC=FALSE
      if [ -z "$IN_NIX_SHELL" ]; then
          source $HOME/.nix-profile/etc/profile.d/nix.sh
          export NIX_PATH=$NIX_PATH:$HOME/.nix-defexpr/channels
      fi
    '' + readFile (confkit.file "zsh/config/home_init.zsh"));

    # Add nix because auto-completion does not work out of the box on non NixOS
    # or nix-darwin platform for now.
    oh-my-zsh.plugins = [ "dnf" "nix" ];

    shellAliases = {
      # Commandes fréquentes.
      op = "xdg-open";

      sr = "pkill -x sxhkd && sxhkd";

      # Emacs
      eds = "emacs --daemon";
      edp = "emacsclient -e \"(kill-emacs)\"";
      edr = "edp && sleep 1 && eds";

      # Restart services
      rc = "systemctl --user restart compton";
      rp = "systemctl --user restart polybar";

      # Configuration Git perso.
      gitp = "git config user.name \"Jean-Philippe Cugnet\" && git config user.email ***";
    };
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  # Compositor for windows transparency.
  services.compton = {
    enable = true;
  };

  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Musique";
    extraConfig = readFile ./mpd/mpd.conf;
  };

  services.polybar = {
    script = mkDefault "polybar main & polybar second-screen &";

    config = {
      "bar/main" = {
        monitor = "HDMI-1";
        fixed-center = false;

        width = "100%";
        height = 30;

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
        modules-right = "alsa temperature memory cpu eth date";

        # TODO: Set locale when on NixOS.
        # locale = "fr_FR.UTF-8";

        wm-restack = "bspwm";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
      };

      "bar/second-screen" = {
        monitor = "VGA-1";
        fixed-center = false;

        width = "100%";
        height = 28;

        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        line-size = 3;
        line-color = "#f00";

        padding-left = 0;
        padding-right = 2;

        module-margin-left = 1;
        module-margin-right = 2;

        font-0 = "NotoSansMono Nerd Font:size=8:weight=bold;0";

        modules-left = "bspwm";
        modules-center = "";
        modules-right = "temperature memory cpu eth date";

        # TODO: Set locale when on NixOS.
        # locale = "fr_FR.UTF-8";

        tray-position = "right";
        tray-padding = 2;

        wm-restack = "bspwm";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
      };

      "module/alsa" = {
        type = "internal/alsa";

        master-mixer = "PCM";
        master-soundcard = "hw:1";

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

      "module/eth" = {
        type = "internal/network";
        interface = "eno1";
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
    };
  };
}
